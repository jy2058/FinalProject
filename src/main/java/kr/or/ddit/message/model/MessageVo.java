package kr.or.ddit.message.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class MessageVo {
	
	private int msgNo;			//쪽지번호
	private String senderId;	//보내는(송신)회원아이디
	
	/*@DateTimeFormat(pattern="yy-MM-dd")*/
	private Date sendDt;		//보낸 날짜
	private String receiverId;	//받는 사람
	private String msgContent;	//내용
	private String msgType;		//쪽지구분 (수락/거절 버튼 필요한지 / 안 필요한지)
	
	
	
	public MessageVo() {
	}
	
	public int getMsgNo() {
		return msgNo;
	}
	public void setMsgNo(int msgNo) {
		this.msgNo = msgNo;
	}
	public String getSenderId() {
		return senderId;
	}
	public void setSenderId(String senderId) {
		this.senderId = senderId;
	}
	public Date getSendDt() {
		return sendDt;
	}
	public void setSendDt(Date sendDt) {
		this.sendDt = sendDt;
	}
	public String getReceiverId() {
		return receiverId;
	}
	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
	}
	public String getMsgContent() {
		return msgContent;
	}
	public void setMsgContent(String msgContent) {
		this.msgContent = msgContent;
	}
	public String getMsgType() {
		return msgType;
	}
	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}
	
	@Override
	public String toString() {
		return "MessageVo [msgNo=" + msgNo + ", senderId=" + senderId + ", sendDt=" + sendDt + ", receiverId="
				+ receiverId + ", msgContent=" + msgContent + ", msgType=" + msgType + "]";
	}

	
}
