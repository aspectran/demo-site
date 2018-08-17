<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="term_demo" style="margin: 30px auto;"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.1/js/jquery.terminal.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.19.1/css/jquery.terminal.min.css" rel="stylesheet"/>
<script>
    $(function() {
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
                                    if (params && params.length > 0) {
                                        term.echo("Required parameters:");
                                        enterEachParameter(params, term);
                                    }
                                    var attrs = request.attributes;
                                    if (attrs && attrs.length > 0) {
                                        term.echo("Required attributes:");
                                        enterEachParameter(attrs, term);
                                    }
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
    function enterEachParameter(params, term) {
        term.echo("Enter a value for each token:");
        var missingParams = [];
        var pp = 0;
        for (var p = params.length - 1; p >= 0; p--) {
            term.push(function (value, term) {
                var mandatory = params[pp].mandatory;
                if (mandatory && value === '') {
                    params[pp].missing = (params[pp].missing||0) + 1;
                    missingParams.push(params[pp]);
                } else {
                    params[pp].value = value;
                    params[pp].missing = 0;
                }
                pp++;
                term.pop();

                if (pp === params.length) {
                    if (missingParams.length > 0) {
                        if (missingParams[0].missing < 2) {
                            term.echo("Missing required parameters.");
                            enterEachParameter(missingParams, term);
                        } else {
                            term.echo("Missing required parameters:");

                        }
                    }
                }
            }, {
                prompt: p + "  " + params[p].string + ": ",
                maskChar: params[p].security ? '*' : false
            });
        }
    }
</script>