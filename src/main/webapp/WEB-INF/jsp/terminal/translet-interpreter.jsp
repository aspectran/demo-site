<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="term_demo" style="margin: 30px auto;"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.0/js/jquery.terminal.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.0/css/jquery.terminal.min.css" rel="stylesheet"/>
<script>
    $(function() {
        $('#term_demo').terminal(function(command, term) {
            term.pause();
            $.post('/terminal/exec', {translet: command}).then(function(response) {
                term.echo(response).resume();
            });
        }, {
            greetings: 'Translet Interpreter',
            name: 'js_demo',
            height: 500,
            width: "100%",
            prompt: 'js> '
        });
    });
</script>