package so.wwb.gamebox.test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.soul.commons.security.CryptoTool;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import so.wwb.gamebox.pcenter.session.SessionManager;

/**
 * Created by Kevice on 2015/1/29.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath*:conf/*-appCtx.xml")
@Transactional
public abstract class BaseTestCase extends Mockito {

	@Test
	public void test() {
		String invitationCode = "926" + "||" + "u1d383";
		System.out.print( CryptoTool.aesEncrypt(invitationCode));
	}

}
