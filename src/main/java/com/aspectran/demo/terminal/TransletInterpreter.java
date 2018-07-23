package com.aspectran.demo.terminal;

import com.aspectran.core.activity.Activity;
import com.aspectran.core.activity.Translet;
import com.aspectran.core.component.bean.annotation.Action;
import com.aspectran.core.component.bean.annotation.Request;
import com.aspectran.core.component.bean.annotation.RequestAsGet;
import com.aspectran.core.component.bean.annotation.RequestAsPost;
import com.aspectran.core.component.bean.annotation.Transform;
import com.aspectran.core.component.bean.aware.ActivityContextAware;
import com.aspectran.core.component.translet.TransletNotFoundException;
import com.aspectran.core.context.ActivityContext;
import com.aspectran.core.context.rule.ItemRuleMap;
import com.aspectran.core.context.rule.TransletRule;
import com.aspectran.core.context.rule.type.TransformType;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class TransletInterpreter implements ActivityContextAware {

    private ActivityContext context;

    @Override
    public void setActivityContext(ActivityContext context) {
        this.context = context;
    }

    @Request(translet = "/exec")
    @Transform(type = TransformType.JSON)
    public Map<String, Object> execute(Translet translet) {
        String transletName = translet.getParameter("translet");

        TransletRule transletRule = context.getTransletRuleRegistry().getTransletRule(transletName);
        if (transletRule == null) {
            throw new TransletNotFoundException(transletName);
        }

        ItemRuleMap parameterItemRuleMap = transletRule.getRequestRule().getParameterItemRuleMap();
        ItemRuleMap attributeItemRuleMap = transletRule.getRequestRule().getAttributeItemRuleMap();

        Map<String, Object> result = new HashMap<>();

        if (parameterItemRuleMap == null && attributeItemRuleMap == null) {

        } else {

        }

        return result;
    }

    private Activity performActivity(String transletName) {
        Activity activity = context.getCurrentActivity().newActivity();
        activity.prepare(transletName);
        activity.perform();
        return activity;
    }

}