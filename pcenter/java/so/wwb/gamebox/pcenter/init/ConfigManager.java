package so.wwb.gamebox.pcenter.init;

import org.soul.commons.spring.utils.SpringTool;

/**
 * Created by tony on 15-4-28.
 */
public class ConfigManager extends so.wwb.gamebox.web.init.ConfigBase {

    public static PCenterConfigration get() {
        return SpringTool.getBean(PCenterConfigration.class);
    }

}
