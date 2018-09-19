<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
    .terminal-wrapper textarea {
        box-shadow: none;
        min-height: initial;
        min-width: initial;
    }
</style>
<div id="skylark-term" style="margin: 30px auto;"></div>
<script src="https://cdn.rawgit.com/jcubic/jquery.terminal/master/js/jquery.terminal.min.js"></script>
<link href="https://cdn.rawgit.com/jcubic/jquery.terminal/master/css/jquery.terminal.min.css" rel="stylesheet"/>
<script>
    $(function() {
        $('#skylark-term').terminal(function(command, term) {
            if (command !== '') {
                term.pause();
                $.ajax({
                    url: '/skylark/tts',
                    data: {
                        text: command
                    },
                    method: 'POST',
                    dataType: 'text',
                    success: function(data, status, xhr) {
                        var contentType = xhr.getResponseHeader("content-type");
                        if (data) {
                            if (contentType == "audio/wav; base64=") {
                                var html = "<audio controls autoplay>" +
                                    "<source src=\"" + data + "\" type='audio/wav'>" +
                                    "Your browser does not support the audio element.</audio>";
                                term.echo(html, {raw: true});
                            } else {
                                term.echo(data);
                            }
                        }
                    },
                    error: function (xhr) {
                        if (xhr.status == '413') {
                            alert("The text provided was too long.");
                        }
                    },
                    complete: function () {
                        term.resume();
                    }
                });
            } else {
                term.echo('');
            }
        }, {
            greetings: '[Online Text-To-Speech Web Application]\nType what you want to say.',
            name: 'skylark',
            height: 450,
            width: "100%",
            prompt: '> '
        });
    });
</script>