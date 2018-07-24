<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="term_demo" style="margin: 30px auto;"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.0/js/jquery.terminal.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.0/css/jquery.terminal.min.css" rel="stylesheet"/>
<script>
    $(function() {
        var context = {};
        $('#term_demo').terminal(function(command, term) {
            if (command !== '') {
                try {
                    term.pause();
                    $.post('/terminal/exec', {translet: command}).then(function (response) {
                        term.echo(response);
                        term.resume();
                    });
                } catch (e) {
                    term.error(String(e));
                }
            } else {
                term.echo('');
            }
        }, {
            greetings: 'Translet Interpreter',
            name: 'transletInterpreter',
            height: 500,
            width: "100%",
            prompt: 'aspectran> '
        });
    });
</script>