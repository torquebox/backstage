$(document).ajaxStart(function() {
    $('#ajax-spinner').show()
})

$(document).ajaxStop(function() {
    $('#ajax-spinner').hide()
})


function tail_log(url, num_lines, offset, tailing) {
    var params = {num_lines: num_lines, offset: offset};
    $.post(url, params, function(data) {
        logs = $('#log_output');
        if (logs.text().trim() == 'Fetching log...') {
            logs.html('');
        }
        if (data.lines.length > 0) {
            //logs.html(logs.html() + "<br />" + data.lines.join("<br />"));
            //logs.html(logs.html() + "\n" + data.lines.join("\n"));
            logs.html(logs.html() + data.lines.join(""));
            if (tailing) {
                logs.animate({scrollTop: logs.attr("scrollHeight")}, 10);
            }
        }
        if (tailing || data.lines.length > 0) {
            setTimeout("tail_log('" + url + "', " + num_lines + ", " + data.offset + ", + " + tailing + ")", 5000);
        }
    }, "json");
}
