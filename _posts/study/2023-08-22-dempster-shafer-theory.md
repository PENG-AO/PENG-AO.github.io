---
layout: post
title: DS理论
subtitle: Dempster Shafer Theory
tags: 统计 C/C++
required: math code
---

Dempster Shafer Theory (DST)也称证据理论，是概率模型的一种。由Dempster提出，Shafer发展泛化。优势在于能考虑且保留事件的“不确定性”，可以应用于信息融合。本文将简述DST的基本概念并附上C++的简单代码实现。

# 基本概念

首先考虑两个互斥事件$a$与$b$构成的全集$X$，则其幂集$\mathcal{P}(X)=\lbrace\emptyset, \lbrace a\rbrace, \lbrace b\rbrace, \lbrace a, b\rbrace\rbrace$代表所有可能发生的情况。在此定义$mass:\mathcal{P}(X)\to[0,1]$函数。当其满足如下条件时，称为基本概率分配(basic probability assignment)。

$$
\begin{cases}
mass(\emptyset) = 0\\
\sum_{A\in\mathcal{P}(X)}mass(A)=1
\end{cases}
$$

那么，事件$A$的可信度可以由$belief$函数和$plausibility$函数确定其上下界。其中$belief$函数代表该事件的可信度，$plausibility$函数代表不否定该事件的可信度。

$$
\begin{cases}
Bel(A)=\sum_{B\subset A}mass(B)\\
Pl(A)=\sum_{B\cap A\ne\emptyset}mass(B)=1-Bel(\neg A)
\end{cases}
$$

最后是DS理论的核心：基本概率分配的合成。给定两组基本概率分配$m_1$和$m_2$，则

$$
(m_1\oplus m_2)(A)=K^{-1}\sum_{B\cap C=A}m_1(B)m_2(C)
$$

其中$K=\sum_{B\cap C\ne\emptyset}m_1(B)m_2(C)$。

同时基于集合运算的结合律，不难证明基本概率分配合成也满足结合律。

$$
m_1\oplus m_2\oplus m_3=(m_1\oplus m_2)\oplus m_3
$$

# 代码实现

```cpp
#include <initializer_list>

#include <Eigen/Core>

template<size_t size>
class DST {
    template<typename T>
    using Vector = Eigen::Array<T, size, 1>;
    template<typename T>
    using Matrix = Eigen::Array<T, size, size>;

public:
    DST(std::initializer_list<Vector<float>> BPAs) {
        // init the mask table
        for (auto row { 0 }; row < size; ++row) {
            for (auto col { 0 }; col < size; ++col) {
                this->mask(row, col) = row & col;
            }
        }
        // calculate combined BPA
        auto iter { BPAs.begin() };
        this->set(*iter++);
        while (iter != BPAs.end()) {
            this->combine(*iter++);
        }
    }

    void set(Vector<float> value) {
        this->BPA = value;
    }

    void combine(Vector<float> value) {
        const Matrix<float> product { this->BPA.replicate(1, size).rowwise() * value.transpose() };
        for (auto idx { 1 }; idx < size; ++idx) {
            this->BPA(idx) = ((this->mask == idx).template cast<float>() * product).sum();
        }
        this->BPA /= ((this->mask != 0).template cast<float>() * product).sum();
    }

    Vector<float> mass() {
        return this->BPA;
    }

    template<typename T>
    float mass(T event) {
        return this->BPA.coeff(static_cast<int>(event));
    }

    Vector<float> belief() {
        Matrix<size_t> filter;
        for (auto row { 1 }; row < size; ++row) {
            filter.row(row) = row;
        }
        return ((this->mask >= filter).template cast<float>().colwise() * this->BPA).colwise().sum();
    }

    template<typename T>
    float belief(T event){
        return this->belief().coeff(static_cast<int>(event));
    }

    Vector<float> plausibility() {
        return ((this->mask != 0).template cast<float>().colwise() * this->BPA).colwise().sum();
    }

    template<typename T>
    float plausibility(T event) {
        return this->plausibility().coeff(static_cast<int>(event));
    }

private:
    Vector<float> BPA;
    Matrix<size_t> mask;
};
```

在此设想比较两个时刻的空间变化的场景：基本事件为$consistent$和$conflicting$，则所有可能事件为$\emptyset$、$\lbrace consistent\rbrace$、$\lbrace conflicting\rbrace$、$\lbrace consistent, conflicting\rbrace$。其中可将$consistent$和$conflicting$的并集改写为$unknown$。后可在测试文件中作如下验证。

```cpp
int main(int argc, char* argv[]) {
    enum class TemporalState { null, consistent, conflicting, unknown };

    DST<4> dst {
        { 0.0, 0.3, 0.6, 0.1 }, // the 1st BPA
        { 0.0, 0.4, 0.5, 0.1 }, // the 2nd BPA
    };

    std::cout << dst.mass(TemporalState::consistent) << std::endl;
    std::cout << dst.mass(TemporalState::conflicting) << std::endl;
    std::cout << dst.mass(TemporalState::unknown) << std::endl;

    return 0;
}
```
