// copied from https://github.com/picocss/pico/blob/master/docs/js/src/theme-switcher.js

const themeSwitcher = {
    // Config
    _scheme: "auto",
    change: {
        light: `<i class="fa-regular fa-lightbulb faa-flash faa-slow"></i>`,
        dark: `<i class="fa-solid fa-lightbulb faa-flash faa-slow"></i>`,
    },
    buttonsTarget: ".theme-switcher",
    localStorageKey: "picoPreferredColorScheme",

    // Init
    init() {
        this.scheme = this.schemeFromLocalStorage
        this.initSwitchers()
    },

    // Get color scheme from local storage
    get schemeFromLocalStorage() {
        if (typeof window.localStorage !== "undefined") {
            if (window.localStorage.getItem(this.localStorageKey) !== null) {
                return window.localStorage.getItem(this.localStorageKey)
            }
        }
        return this._scheme
    },

    // Preferred color scheme
    get preferredColorScheme() {
        return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
    },

    // Init switchers
    initSwitchers() {
        const buttons = document.querySelectorAll(this.buttonsTarget)
        buttons.forEach(button => {
            button.addEventListener("click", () => {
                this.scheme == "dark" ? this.scheme = "light" : this.scheme = "dark"
            }, false)
        })
    },

    // Set scheme
    set scheme(scheme) {
        if (scheme == "auto") {
            this.preferredColorScheme == "dark" ? this._scheme = "dark" : this._scheme = "light"
        }
        else if (scheme == "dark" || scheme == "light") {
            this._scheme = scheme
        }
        this.applyScheme()
        this.schemeToLocalStorage()
    },

    // Get scheme
    get scheme() {
        return this._scheme
    },

    // Apply scheme
    applyScheme() {
        document.querySelector("html").setAttribute("data-theme", this.scheme)
        const buttons = document.querySelectorAll(this.buttonsTarget)
        buttons.forEach(
            button => {
                const text = this.scheme == "dark" ? this.change.dark : this.change.light
                button.innerHTML = text
                button.setAttribute("aria-label", text.replace(/<[^>]*>?/gm, ""))
            }
        )
    },

    // Store scheme to local storage
    schemeToLocalStorage() {
        if (typeof window.localStorage !== "undefined") {
            window.localStorage.setItem(this.localStorageKey, this.scheme)
        }
    },
}

// init theme switcher
function initThemeSwitcher() {
    window.addEventListener("load", () => {
        let button = document.createElement("button")
        button.className = "theme-switcher contrast faa-parent animated-hover"
        button.style.order = -2
        document.querySelector(".button-box").appendChild(button)
        themeSwitcher.init()
    })
}