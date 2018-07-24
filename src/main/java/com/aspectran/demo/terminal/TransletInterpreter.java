package com.aspectran.demo.terminal;

import com.aspectran.core.activity.Activity;
import com.aspectran.core.activity.Translet;
import com.aspectran.core.activity.response.transform.json.ContentsJsonWriter;
import com.aspectran.core.component.bean.annotation.Configuration;
import com.aspectran.core.component.bean.annotation.Request;
import com.aspectran.core.component.bean.annotation.Transform;
import com.aspectran.core.component.bean.aware.ActivityContextAware;
import com.aspectran.core.component.translet.TransletNotFoundException;
import com.aspectran.core.context.ActivityContext;
import com.aspectran.core.context.rule.ItemRule;
import com.aspectran.core.context.rule.ItemRuleMap;
import com.aspectran.core.context.rule.TransletRule;
import com.aspectran.core.context.rule.type.TransformType;
import com.aspectran.core.util.StringUtils;

import java.io.IOException;
import java.io.Writer;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Configuration(namespace = "/terminal")
public class TransletInterpreter implements ActivityContextAware {

    private static final String COMMAND_PREFIX = "/terminal/";

    private ActivityContext context;

    @Override
    public void setActivityContext(ActivityContext context) {
        this.context = context;
    }

    @Request(translet = "/exec")
    @Transform(type = TransformType.TEXT)
    public void execute(Translet translet) throws IOException, InvocationTargetException {
        String transletName = translet.getParameter("translet");
        if (StringUtils.isEmpty(transletName)) {
            return;
        }

        String transletFullName = COMMAND_PREFIX + transletName;

        TransletRule transletRule = context.getTransletRuleRegistry().getTransletRule(transletFullName);
        if (transletRule == null) {
            throw new TransletNotFoundException(transletName);
        }

        ItemRuleMap parameterItemRuleMap = transletRule.getRequestRule().getParameterItemRuleMap();
        ItemRuleMap attributeItemRuleMap = transletRule.getRequestRule().getAttributeItemRuleMap();

        Writer writer = translet.getResponseAdapter().getWriter();

        if (parameterItemRuleMap == null && attributeItemRuleMap == null) {
            writer.write("result: ");
            performActivity(transletRule);
        } else {
            writer.write("require: {");
            if (parameterItemRuleMap != null) {
                writer.write("parameters: ");
                ContentsJsonWriter jsonWriter = new ContentsJsonWriter(writer);
                jsonWriter.write(toList(parameterItemRuleMap));
            }
            if (attributeItemRuleMap != null) {
                writer.write("attributes: ");
                ContentsJsonWriter jsonWriter = new ContentsJsonWriter(writer);
                jsonWriter.write(toList(attributeItemRuleMap));
            }
            writer.write("}");
        }
    }

    private void performActivity(TransletRule transletRule) {
        Activity activity = context.getCurrentActivity().newActivity();
        activity.prepare(transletRule);
        activity.perform();
    }

    private List<Map<String, Object>> toList(ItemRuleMap itemRuleMap) {
        List<Map<String, Object>> list = new ArrayList<>();
        for (ItemRule itemRule : itemRuleMap.values()) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("type", itemRule.getType().toString());
            map.put("name", itemRule.getName());
            map.put("value", itemRule.getValue());
            map.put("defaultValue", itemRule.getDefaultValue());
            map.put("mandatory", itemRule.isMandatory());
            map.put("security", itemRule.isSecurity());
            list.add(map);
        }
        return list;
    }

}