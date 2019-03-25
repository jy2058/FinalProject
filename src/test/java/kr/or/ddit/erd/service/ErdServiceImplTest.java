package kr.or.ddit.erd.service;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.junit.Test;
import org.slf4j.LoggerFactory;

import ch.qos.logback.classic.Logger;
import kr.or.ddit.erd.model.ErdVo;
import kr.or.ddit.team.model.TagVo;
import kr.or.ddit.test.logicTestConfig;

public class ErdServiceImplTest extends logicTestConfig{
	private Logger logger = (Logger) LoggerFactory.getLogger(ErdServiceImplTest.class);
	@Resource(name="erdService")
	private IErdService erdService;

	/**
	* Method : testAddErd
	* 작성자 : PC08
	* 변경이력 :
	* Method 설명 : erd 생성 테스트
	*/
	@Test
	public void testAddErd() {
		/***Given***/
		ErdVo erdVo = new ErdVo();
		
		erdVo.setErdTitle("테스트코드서비스타이틀");
		erdVo.setErdScope("public");
		erdVo.setMemId("user3");
		erdVo.setTeamNo(1);
		/***When***/
		int addCnt = erdService.addErd(erdVo);

		/***Then***/
		assertEquals(addCnt, 1);
		
	}
	
	/*@Test
	public void testAddErdTagFull() {
		*//***Given***//*
		ErdVo erdVo = new ErdVo();
		
		String tag = "1,3,4,5";
		
		
		erdVo.setErdTitle("테스트코드고친거");
		erdVo.setErdScope("public");
		erdVo.setMemId("user3");

		*//***When***//*
		int addCnt = erdService.addErdTag(erdVo, tag);

		*//***Then***//*
		assertEquals(addCnt, 1);
		
	}
*/
	
	/**
	* Method : testGetMyErdList
	* 작성자 : PC08
	* 변경이력 :
	* Method 설명 : 나의 erd 리스트 가져오기 테스트
	*/
	@Test
	public void testGetMyErdList(){
		/***Given***/
		String memId = "user3";
		/***When***/
		List<ErdVo> myErdList = erdService.getMyErdList(memId);

		/***Then***/
		assertNotNull(myErdList);

	}
	
	@Test
	public void testGetMyErdTagList(){
		/***Given***/
		
		String memId = "user3";
		int erdNo = 1035;
		/***When***/
		Map<String, Object> myErdTagList = erdService.getMyErdTagMap(memId);
		/***Then***/
		List<ErdVo> myErdList = (List<ErdVo>) myErdTagList.get("myErdList");
		logger.debug("===myErdList : {}", myErdList);
		Map<Integer, List<TagVo>> erdTagListMap = (Map<Integer, List<TagVo>>) myErdTagList.get("erdTagListMap");
		List<TagVo> list = erdTagListMap.get(erdNo);
		
		logger.debug("===List : {}", list);
		
	}
}
