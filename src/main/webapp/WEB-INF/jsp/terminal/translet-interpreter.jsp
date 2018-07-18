<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="term_demo" style="margin: 30px auto;"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.18.0/js/jquery.terminal.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.18.0/css/jquery.terminal.min.css" rel="stylesheet"/>
<script>
    jQuery(function($, undefined) {
        $('#term_demo').terminal(function(command) {
            if (command !== '') {
                var result = window.eval(command);
                if (result != undefined) {
                    this.echo(String(result));
                }
            }
        }, {
            greetings: 'Translet Interpreter',
            name: 'js_demo',
            height: 500,
            width: "90%",
            prompt: 'js> '
        });
    });
</script>