<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
    .terminal-wrapper textarea {
        box-shadow: none;
        min-height: initial;
        min-width: initial;
    }
</style>
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
                        url: '/terminal/query/' + command,
                        method: 'GET',
                        dataType: 'json',
                        success: function(data) {
                            var prompts = [];
                            if (data.response) {
                                term.echo(response);
                            } else {
                                var request = data.request;
                                if (request) {
                                    var prev = null;
                                    var params = request.parameters;
                                    if (params && params.tokens) {
                                        for (var i = 0; i < params.tokens.length; i++) {
                                            var token = params.tokens[i];
                                            var item = {
                                                command: command,
                                                group: 'parameters',
                                                prev: prev,
                                                next: null,
                                                token: token,
                                                items: token.items
                                            };
                                            prompts.push(item);
                                            if (prev) {
                                                prev.next = item;
                                            }
                                            prev = item;
                                            console.log(item);
                                        }
                                    }
                                    var attrs = request.attributes;
                                    if (attrs && attrs.tokens) {
                                        for (var i = 0; i < attrs.tokens.length; i++) {
                                            var token = attrs.tokens[i];
                                            var item = {
                                                command: command,
                                                group: 'attributes',
                                                prev: prev,
                                                next: null,
                                                token: token,
                                                items: token.items
                                            };
                                            prompts.push(item);
                                            if (prev) {
                                                prev.next = item;
                                            }
                                            prev = item;
                                            console.log(item);
                                        }
                                    }
                                }
                                if (prompts.length > 0) {
                                    prompts[prompts.length - 1].terminator = true;
                                    enterEachToken(term, prompts[0], true);
                                }
                            }
                        },
                        complete: function () {
                            term.resume();
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
            prompt: 'Aspectran> '
        });
    });
    function enterEachToken(term, prompt, first, missed) {
        if (first) {
            if (missed) {
                term.echo("Missing required " + prompt.group + ":");
            } else {
                term.echo("Required " + prompt.group + ":");
            }

            term.echo("Enter a value for each token:");
        }
        term.push(function (value, term) {
            var token = prompt.token;
            var mandatory = token.mandatory;
            if (mandatory && value === '') {
                prompt.done = false;
            } else {
                prompt.value = value;
                prompt.done = true;
            }
            term.pop();
            if (prompt.terminator) {
                execCommand(term, prompt);
            } else if (prompt.next) {
                var next = prompt.next;
                while (next) {
                    if (next.done) {
                        if (next.terminator) {
                            execCommand(term, prompt);
                            break;
                        }
                    } else {
                        enterEachToken(term, next);
                        break;
                    }
                    next = prompt.next;
                }
            }
        }, {
            prompt: prompt.token.string + ": "
        });
    }
    function execCommand(term, prompt) {
        var root = prompt;
        while (root.prev) {
            root = root.prev;
        }
        var params = {};
        var curr = root;
        while (curr) {
            params[curr.token.name] = curr.value;
            curr = curr.next;
        }
        try {
            term.pause();
            $.ajax({
                url: '/terminal/exec/' + prompt.command,
                data: params,
                method: 'POST',
                dataType: 'text',
                success: function(data) {
                    if (data) {
                        term.echo(data);
                    }
                },
                complete: function () {
                    term.resume();
                }
            });
        } catch (e) {
            term.error(String(e));
        }
    }
</script>