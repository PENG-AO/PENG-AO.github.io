---
---

# init tab view

window.initTabView = (container, controller) ->
    switchTab = (e) ->
        toClose =
            map: container.querySelector(".travel-map[active]")
            btn: controller.querySelector("button[active]")
        toClose.map?.removeAttribute("active")
        toClose.btn?.removeAttribute("active")
        toOpen =
            map: container.querySelector(e.target.getAttribute("data-target"))
            btn: e.target
        toOpen.map?.setAttribute("active", "")
        toOpen.btn?.setAttribute("active", "")
        return
    
    for button in controller.querySelectorAll("button")
        do (button) ->
            button.onclick = switchTab
            return
    return
