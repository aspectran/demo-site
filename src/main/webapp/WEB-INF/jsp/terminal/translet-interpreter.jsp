<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="term_demo" style="margin: 30px auto;"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.1/js/jquery.terminal.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.1/css/jquery.terminal.min.css" rel="stylesheet"/>
<script>
    var a = {
        translet: {"name":"/terminal/hello","description":null},
        request: {
            parameters: [
                {"type":"single","name":"param1","value":"","defaultValue":null,"mandatory":true,"security":false},
                {"type":"single","name":"param2","value":"","defaultValue":null,"mandatory":true,"security":false}
            ]
        },
        contentType: "text/plain"
    };
    $(function() {
        var context = {};
        $('#term_demo').terminal(function(command, term) {
            if (command !== '') {
                try {
                    term.pause();
                    $.ajax({
                        url: '/terminal/exec',
                        data: {
                            _translet: command
                        },
                        method: 'GET',
                        dataType: 'json',
                        success: function(data) {
                            if (data.response) {
                                term.echo(response);
                                term.resume();
                            } else {
                                term.resume();
                                var request = data.request;
                                if (request) {
                                    var params = request.parameters;
                                    if (params) {
                                        term.echo("Required parameters:");
                                        for (var p in params) {
                                            var param = params[p];
                                            term.push(function (command, term) {
                                                term.echo(param.name);
                                                term.pop();
                                            }, {
                                                prompt: "  " + param.name + ": "
                                            });
                                        }
                                    }
                                    var attrs = request.attributes;
                                }
                            }
                        }
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