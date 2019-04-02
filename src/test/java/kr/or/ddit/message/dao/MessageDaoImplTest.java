package kr.or.ddit.message.dao;

import static org.junit.Assert.*;

import java.util.List;

import javax.annotation.Resource;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.or.ddit.message.model.MessageVo;
import kr.or.ddit.test.logicTestConfig;

public class MessageDaoImplTest extends logicTestConfig{
	private Logger logger = LoggerFactory.getLogger(MessageDaoImplTest.class);
	
	@Resource(name="messageDao")
	private IMessageDao messageDao;

	/**
	* Method : testGetAllMsg
	* 작성자 : PC08
	* 변경이력 :
	* Method 설명 : 멤버 별 메시지 조회
	*/
	@Test
	public void testGetAllMsg() {
		/***Given***/
		String memId = "user2";
		/***When***/
		List<MessageVo> allMsg = messageDao.getAllMsg(memId);

		/***Then***/
		assertNotNull(allMsg);
		logger.debug("===allMsg : {}", allMsg);
	}

}
