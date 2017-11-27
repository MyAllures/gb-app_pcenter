package so.wwb.gamebox.pcenter.init;

import org.soul.commons.spring.utils.SpringTool;
import so.wwb.gamebox.web.init.ExtBaseConfigManager;

/**
 * Created by tony on 15-4-28.
 */
public class ConfigManager extends ExtBaseConfigManager {

    public static PCenterConfigration getConfigration() {
        return SpringTool.getBean(PCenterConfigration.class);
    }

}
