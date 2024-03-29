---
---

# generate popup gallery for gallery images

formatFNumber = (f) ->
    if not f?
        undefined
    else
        "f/#{f.toFixed(1)}"

formatExposure = (e) ->
    if not e?
        undefined
    else if e < 1
        "1/#{Math.floor(1 / e)}s"
    else
        "#{e}s"

formatISO = (iso) ->
    if not iso?
        undefined
    else
        "ISO#{iso}"

formatOpticalInfo = (exif) ->
    info = (value for value in [
        formatFNumber(exif?.FNumber),
        formatExposure(exif?.ExposureTime),
        formatISO(exif?.ISOSpeed ? exif?.ISO)
    ] when value?).join(" ")
    if info.length > 0 then info else undefined

formatLocation = (loc) ->
    if loc.length > 0 then loc else undefined

updateCaption = (img) ->
    cap = document.querySelector(".lg-container.lg-show .lg-sub-html")
    window.exifr.parse(img).then((exif) ->
        cap.innerHTML = (item for item in [
            exif?.Model,
            exif?.LensModel,
            formatOpticalInfo(exif),
            exif?.DateTimeOriginal?.toLocaleString(),
            formatLocation(cap.innerText.trim()),
        ] when item?).join("<br>")
        return
    )

window.initGallery = (gallery, data) ->
    # load photos to gallery
    plugin = [lgZoom, lgAutoplay]
    unless data.length > 50 then plugin.push(lgThumbnail)
    window.lightGallery(gallery, {
        plugins: plugin
        container: gallery
        dynamic: true
        dynamicEl: ({
            src: item.src
            thumb: item.src
            subHtml: ("<br>" for i in [0...4]).join("") + item.loc
        } for item in data)
        mode: "lg-zoom-in-out"
        closable: false
        slideShowAutoPlay: false
    }).openGallery()
    # insert exif info
    gallery.addEventListener("lgAfterSlide", () ->
        updateCaption(document.querySelector(".lg-container.lg-show .lg-current img"))
    )
    # activate maximize button
    document.getElementById("gallery-btn").setAttribute("active", "")
    return

window.maximizeGallery = () ->
    if gallery.hasAttribute("maximized")
        gallery.removeAttribute("maximized")
        gallery.style.setProperty("position", "relative")
        document.documentElement.removeAttribute("fullscreen")
        window.scrollTo({top: gallery.offsetTop - (window.innerHeight - gallery.offsetHeight) / 2})
    else
        gallery.setAttribute("maximized", '')
        gallery.style.removeProperty("position")
        document.documentElement.setAttribute("fullscreen", "")
        window.scrollTo({top: 0})
    return
