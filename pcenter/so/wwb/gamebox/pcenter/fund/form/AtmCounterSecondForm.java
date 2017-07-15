package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.model.common.RegExpConstants;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;

import javax.validation.constraints.Pattern;

/**
 * Created by Cherry on 16-6-28.
 */
@Comment("柜员机转账第二步验证")
public class AtmCounterSecondForm implements IForm {
    private String result_rechargeAddress;
    private String result_payerName;

    @Comment("存款人")
    @Depends(message = "fund.rechargeForm.result.payerName.notBlank", property = "result.rechargeType", operator = Operator.NE, value = RechargeTypeEnum.RECHARGE_TYPE_ATM_MONEY)
    @Pattern(message = "fund.rechargeForm.payerName.pattern", regexp = RegExpConstants.REALNAME)
    @Length(min = 2, max = 30)
    public String getResult_payerName() {
        return result_payerName;
    }

    public void setResult_payerName(String result_payerName) {
        this.result_payerName = result_payerName;
    }

    @Comment("交易地点")
    @Depends(message = "fund.rechargeForm.result.rechargeAddress.notBlank", property = "result.rechargeType", operator = Operator.EQ, value = RechargeTypeEnum.RECHARGE_TYPE_ATM_MONEY)
    @Length(max = 50)
    public String getResult_rechargeAddress() {
        return result_rechargeAddress;
    }

    public void setResult_rechargeAddress(String result_rechargeAddress) {
        this.result_rechargeAddress = result_rechargeAddress;
    }

}
