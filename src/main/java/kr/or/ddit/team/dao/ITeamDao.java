package kr.or.ddit.team.dao;

import java.util.List;

import kr.or.ddit.team.model.TagVo;
import kr.or.ddit.team.model.TeamListVo;
import kr.or.ddit.team.model.TeamVo;

public interface ITeamDao {

	/**
	* Method : getTeamAllList
	* 작성자 : kjy
	* 변경이력 :
	* @param memId
	* @return
	* Method 설명 : 팀 리스트 조회
	*/
	List<TeamListVo> getTeamAllList(String memId);
	
	
	/**
	* Method : getTeamInfo
	* 작성자 : kjy
	* 변경이력 :
	* @param teamNo
	* @return
	* Method 설명 : 회원의 팀 정보 조회
	*/
	TeamVo getTeamInfo(int teamNo);
	
	/**
	* Method : insertTag
	* 작성자 : kjy
	* 변경이력 :
	* @param tagVo
	* @return
	* Method 설명 : 태그 insert
	*/
	int insertTag(TagVo tagVo);
}
