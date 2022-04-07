$(function () {
    $(".container").hide()
    window.addEventListener('message', function(event) {
        const v = event.data;
        if (v.type == 'enter') {
            var zona = v.zone;
            var desc = v.description;
            $(".container").show()
            $(".container").removeClass("hide")
            $(".container").addClass("show")
            $(".zone").text("Estás en " + zona)
            $(".desc").text(desc)
        } else if (v.type == 'exit') {
            $(".container").removeClass("show")
            $(".container").addClass("hide")
        } else if (v.type == 'disable') {
            $(".container").hide()
        }
    })
});