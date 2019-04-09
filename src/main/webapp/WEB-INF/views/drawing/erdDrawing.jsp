<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/erdDrawing.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://unpkg.com/konva@3.2.0/konva.min.js"></script>
<script src="/js/drawing/minimap.js"></script>
<script src="/js/drawing/attribute.js"></script>
<script src="/js/drawing/style.js"></script>
<script src="/js/drawing/realation.js"></script>
</head>

<body id='my_body'>

	<div id="drawing_container">
		<div class="drawing_top">
			<a id="botton0" class="buttons" href="/">홈</a>
			<div id="button1" class="buttons">테이블 이름 가져오기</div>
			<div id="button2" class="buttons">확대/축소 초기화</div>
			<div id="button3" class="buttons">테이블 추가하기</div>
			<div id="button4" class="buttons">미니맵 Toggle</div>
            <div id="button5" class="buttons">1대1 연결</div>
			<div id="button6" class="buttons">1대 다 연결</div>
			<div id="line_background" class ="identify_hs">
				<div id="lineInformation">
					<div id="identifying">identifying RelationShip</div>
					<div id="nonidentifying">Non - identifying RelationShip</div>		
				</div>
			</div>
		</div>
	<div id="container_mini"></div>
		
        <div class="drawing_box">

            <session class="drawing_left drawing_pannel">
                L
            </session>

            <session class="drawing_right drawing_pannel">
                R
            </session>

            <session class="drawing_bottom drawing_pannel">
                
                <label><input type="checkbox" value="attr_logical" class="test_check" checked> 논리 켜기/끄기</label>
                 <label><input type="checkbox" value="attr_phisical" class="test_check" checked> 물리 켜기/끄기</label>
                
                <label><input type="checkbox" value="attr_domain" class="test_check" checked> DOMAIN</label>
                 <label><input type="checkbox" value="attr_type" class="test_check" checked> TYPE</label>
                
                
                <label><input type="checkbox" value="attr_null" class="test_check" checked> NULL</label>
                <label><input type="checkbox" value="attr_default" class="test_check" checked> DEFAULT</label>
                <label><input type="checkbox" value="attr_comment" class="test_check" checked> COMMENT</label>
                 
            </session>

            <session class="drawing_content drawing_pannel">
                <div id="container_Shin"></div>
            </session>

        </div>
    </div>
    
</body>


        



<script>
        
    
    //속성 visible 기본값 설정
    var visible_save = {"attr_logical":true,
                        "attr_phisical":true,
                        "attr_domain":true,
                        "attr_type":true,
                        "attr_null":false,
                        "attr_default":false,
                        "attr_comment":false};
    
    
    //체크박스 초기화
    $(".test_check").each(function(s){
        var setInit_Value = visible_save[$(this).val()];
       $(this).prop("checked",setInit_Value);
    });
    
    //체크박스 선택 이벤트
    $(".test_check").on("change",function(changes){
        
        check_name = $(this).val();
        if($(this).prop("checked")){
            
            stage.find("."+check_name).each(function(get){
                get.parent.attrs.visible = true;
                visible_save[check_name] = true;
            });
        }else{
        
            stage.find("."+check_name).each(function(get){
                get.parent.attrs.visible = false;
                visible_save[check_name] = false;
            });
        }


        layer.find('.entity').each(function(z){
            entity = z;
            stageClick();
        });
        
        stageClick(0);
        
    });
 
   
    

        //버튼 이벤트
        $("#button1").on('click', function(){
           alert(textNode.text());
        });
        $("#button2").on('click', function(){
            
        	//미니맵 빨간 사각형 초기화
        	
            mini_rect.x(0),
  			mini_rect.y(0),
  			mini_rect.width(screenWidth*0.048),
  			mini_rect.height(screenHeight*0.048)
  			
  			mini_layer.draw();
             
           stage.scale({ x: 1, y: 1 });
            stage.position({x:0, y:0});
            stage.batchDraw();
        });
        
        $("#button3").on('click', function(){
            
        
           $('html').css({'cursor':'url(/image/erase.cur), auto'});
           
            
            stage.on("click", function(){
                // what is transform of parent element?
                var transform = layer.getAbsoluteTransform().copy();

                // to detect relative position we need to invert transform
                transform.invert();

              var pos = stage.getPointerPosition();
              var circlePos = transform.point(pos);
              entityAdd(circlePos);
                
                
                $('html').css({'cursor':'default'});
                
                 //stage.off('click');

           });
        });
        
        //관계 연결선 1대 1
        $("#button5").on('click', function(){
      	  $('html').css({'cursor':'url(/image/erase.cur), auto'});
      	  cardinality = 'single';
      	  isRRelationClick = true;
      });
      
      //관계 연결선 1대 다
        $("#button6").on('click', function(){
      	  $('html').css({'cursor':'url(/image/erase.cur), auto'});
      	  cardinality = 'multi';
      	  isRRelationClick = true;
      });
      
      //identifying을 클릭했을 때
        $("#identifying").on('click', function(){
      	  console.log('identifyingclick')
      	  relationType = true;
      $('.identify_hs').css('display','none');
      compareEntityPosition(); 
      });
      
      //nonidentifying을 클릭했을 때
        $("#nonidentifying").on('click', function(){
      	  console.log('nonidentifyingclick')
      	  relationType = false;
      $('.identify_hs').css('display','none');
      compareEntityPosition();
      	  
      });
        
        
        
        
//    1. 변수 선언 및 초기화
      var width = window.innerWidth;
      var height = window.innerHeight;

      var width2 = $('#container_Shin').width();
      var height2 = $('#container_Shin').height();
      
      console.log("width2 : "+width2);
      console.log("height2 : "+height2);
        
      var BORDER_SIZE = 3;

      var color1_num, target, activeWedge, stage, layer, wheel, pointer, box, textNode, allNode;
      
      // entity
      var entity, entity_container, entity_logical, entity_phisical, entity_logical_txt, entity_phisical_txt;
        
      // entity버튼
      var btn_entity_group, btn_entity_delete, btn_color, btn_pk_add, btn_col_add, btn_entity_delete_txt, btn_color_txt, btn_pk_add_txt, btn_col_add_txt;
        
      // attribute group.
      var pk_group, fk_group, attr_group;
    
      //미니맵 관련 전연변수 선언
      var mini_width, mini_height, screenWidth, screenHeight;;
      var mini_stage, mini_layer, mini_rect;

    
      var tmp_PosY = 0;
    
      //yhs
      var isRRelationClick = false;  
      var temp_arrow_layer;
      var temp_arrow;  
      var relationLine; //실제 관계를 연결해주는 선
      var relationLine_layer; 
      var relationType;  //identifying or non-identifying        
      var cardinality //차수 1대1인지 1대 다 인지?
      var firstEntity //첫번째로 클릭한 엔티티
      var secondEntity  //두번째로 클릭한 엔티티
      var relationSwitchFlag;
      
      
    
//    2. ERD화면 초기화
      function init_ERD(){
          
         //기본 레이어 생성
          stage = new Konva.Stage({
            container: 'container_Shin',
            width: width2,
            height: height2,
            draggable: true
          });
          
          layer = new Konva.Layer();
          layer2 = new Konva.Layer();
          
          
          
        // 미니맵용 스테이지 생성
        mini_width = $('#container_mini').width();
		mini_height = $('#container_mini').height();
    
        screenWidth = $('#container_Shin').width();
        screenHeight = $('#container_Shin').height();
    
    
		mini_stage = new Konva.Stage({
			container: 'container_mini',
			width: mini_width,
			height: mini_height
		});
		
		mini_layer = new Konva.Layer();
	
		//미니맵에 보이는 사각형 생성(빨간네모)
		mini_rect = new Konva.Rect({
			x: 0,
			y: 0,
			width: screenWidth*0.048,
			height: screenHeight*0.048,
			stroke: 'red',
			strokeWidth: 2
			/* opacity: 0.3 */
		});
		mini_rect.draggable('true');
		mini_layer.add(mini_rect);
          
          
		  mini_stage.add(mini_layer);
          stage.add(layer).add(layer2);
          
          mini_layer.draw();
          layer.draw();
          
      }  
        
    
      init_ERD();
 

        
//        테이블 생성
        function entityAdd(circlePos){
            
            color1_num = Math.floor(Math.random() * 6);
            //color1_num = 3;
            
            entity = new Konva.Group({
                x: circlePos.x,
                y: circlePos.y,
                opacity: 0.9,
                name: 'entity'
            });
            
            var giveColor = new Konva.Text({
                text: color1_num+'',
                name: 'giveColor',
                visible:false
            });
            
          
            
//            테이블 전체 박스
            entity_container = new Konva.Rect({
                x: 0,
                y: 0,
                width: 200,
                height: 26,
                fill: colorPick[color1_num].entityBg,
                stroke: 'white',
                strokeWidth: 0,
                name: 'entity_container'
            });
            
            //미니맵에 표시할 테이블 생성
            var mini_tb = new Konva.Rect({
				x: circlePos.x*0.048,
				y: circlePos.y*0.048,
				fill: 'black',
				id :entity._id        //메인스테이지 테이블의 id값을 참조함 
				/* opacity: 0.3 */
			});
//            console.log('mini_tb 아이디 :'+mini_tb.id());
//            console.log('entity_container.width:'+entity_container.width());
//            console.log('entity_container.height:'+entity_container.height());
			
            
            entity_logical = new Konva.Rect({
                x: BORDER_SIZE,
                y: BORDER_SIZE,
                width: 98,
                height: 20,
                //fill: '#000000',
                //stroke: 'red',
                name: 'entity_logical'
            });
            
            
            
            entity_phisical = new Konva.Rect({
                x: entity_logical.x() + entity_logical.width(),
                y: BORDER_SIZE,
                width: 98,
                height: 20,
                //fill: '#000000',
                //stroke: 'red',
                name: 'entity_phisical'
            });
            
            entity_logical_txt = new Konva.Text({
                text: '테이블명',
                x: entity_logical.x(),
                y: entity_logical.y(),
                padding: 5,
                fill: colorPick[color1_num].entityColor,
                fontSize: 11,
                name: 'entity_logical_txt'
            });

            entity_phisical_txt = new Konva.Text({
                text: 'TableName' + cntEntity(),
                x: entity_phisical.x(),
                y: entity_phisical.y(),
                padding: 5,
                fill: colorPick[color1_num].entityColor,
                fontSize: 11,
                name: 'entity_phisical_txt'
            });
            
            entity.add(entity_container).add(giveColor);
            entity.add(entity_logical).add(entity_phisical);
            entity.add(entity_logical_txt).add(entity_phisical_txt);
            
//            버튼 생성
            btn_entity_group = new Konva.Group({
                x: 0,
                y: 0,
                visible:false,
                name: 'btn_entity_group'
            });

            //entity 삭제 버튼
            btn_entity_delete = new Konva.Rect({
                x: entity_container.width() -(20-(BORDER_SIZE-1)),
                y: -(20+(BORDER_SIZE-1)),
                width: 20,
                height: 20,
                fill: '#333333',
                //stroke: 'red',
                cornerRadius: 5,
                name: 'btn_entity_delete'
                
            });
            
            btn_entity_delete_txt = new Konva.Text({
                text: 'x',
                x: btn_entity_delete.x()+4,
                y: btn_entity_delete.y()+3.5,
                fill: '#ffffff',
                fontSize: 12,
                name: 'btn_entity_delete_txt'
            });

            
            //색상 변경 버튼
            btn_color = new Konva.Rect({
                x: btn_entity_delete.x() - 21,
                y: btn_entity_delete.y(),
                width: 20,
                height: 20,
                fill: '#333333',
                //stroke: 'red',
                cornerRadius: 5,
                name: 'btn_color'
            });
            
            btn_color_txt = new Konva.Text({
                text: 'o',
                x: btn_color.x()+4,
                y: btn_color.y()+3.5,
                fill: '#ffffff',
                fontSize: 12,
                name: 'btn_color_txt'
            });

            btn_entity_group.add(btn_entity_delete).add(btn_color);
            btn_entity_group.add(btn_entity_delete_txt).add(btn_color_txt);
            
            
            //pk추가 버튼
            btn_pk_add = new Konva.Rect({
                x: -1,
                y: btn_entity_delete.y(),
                width: 20,
                height: 20,
                fill: '#FFD403',
                //stroke: 'red',
                cornerRadius: 5,
                name: 'btn_pk_add'
            });
            
            btn_pk_add_txt = new Konva.Text({
                text: '+',
                x: btn_pk_add.x()+4,
                y: btn_pk_add.y()+1.5,
                fill: '#000000',
                fontSize: 20,
                name: 'btn_pk_add_txt'
            });
            
            
            
            //일반 컬럼 추가 버튼
            btn_col_add = new Konva.Rect({
                x: btn_pk_add.x()+21,
                y: btn_entity_delete.y(),
                width: 20,
                height: 20,
                fill: '#0EB6FF',
                //stroke: 'red',
                cornerRadius: 5,
                name: 'btn_col_add'
            });
            
            btn_col_add_txt = new Konva.Text({
                text: '+',
                x: btn_col_add.x()+4,
                y: btn_col_add.y()+1.5,
                fill: '#000000',
                fontSize: 20,
                name: 'btn_col_add_txt'
            });
            
            
            btn_entity_group.add(btn_pk_add).add(btn_col_add);
            btn_entity_group.add(btn_pk_add_txt).add(btn_col_add_txt);
            
            
           
            
            pk_group = new Konva.Group({
                x: 0,
                y: 26,
                name: 'key_group pk_group'
            });
            
            fk_group = new Konva.Group({
                x: 0,
                y: 0,
                name: 'key_group fk_group'
            });
            
            attr_group = new Konva.Group({
                x: 0,
                y: 0,
                name: 'key_group attr_group'
            });
            
            
            
            layer.add(entity);
            entity.add(btn_entity_group);
            entity.add(pk_group);
			entity.add(fk_group);
            entity.add(attr_group);
            
            entity_resize();
             
            
            
            //리사이즈 된 크기에 맞춰서 미니맵테이블의 크기 설정
            mini_tb.width(entity_container.width()*0.048);
            mini_tb.height(entity_container.height()*0.048);
            
            mini_layer.add(mini_tb);
            mini_rect.zIndex(mini_layer.children.length-1);
            
            
            layer.draw();
            mini_layer.draw();
            
            
             entity.off('dblclick');
             entity.on('dblclick', textClick);
            
            
             stage.off('click');
             stage.on('click', stageClick);

            //yhs================================
             // 엔티티를 클릭했을 경우(mouseup) 엔티티와 관계된 관계선들을 보여준다. 
             entity.on('mouseup',function(e){
             	 console.log('마우스업');
             	 var first_Entity = e.target.findAncestor('.entity'); // 첫번째 객체를 얻어옴 (내가 클릭한 객체)
             	 
             	entityMouseUp(first_Entity,true); 
             	
             }); 
             
          
             // 엔티티를 클릭했을 경우(mousedown) 엔티티와 관계된 관계선들을 숨겨준다.
             entity.on('mousedown',function(e){
            	 console.log('마우스 다운');
            	
            	 // e.target.findAncestor('.entity');
            	 var arr_line_To= relationLine_layer.find('.'+e.target.findAncestor('.entity')._id);
				 
            	 var arr_line_From = findLineRefPos(e.target.findAncestor('.entity')._id);
            	 for(var i=0; i<arr_line_To.length; i++){
            		 arr_line_To[i].hide();
            	 }
            	 
            	 for(var i = 0; i<arr_line_From.length; i++){
            		 arr_line_From[i].hide();
            	 }
            		relationLine_layer.draw();
            });
              
            
            
            //yhs===========================================
            
            
            //dragEvent1
             stage.off('.dragSetup');
             stage.on('dragmove.dragSetup', function dragEvent1(evt){
                 
                 allNode = evt.target;
                 
                     if(allNode.hasName('entity')){
                     console.log("entity : "+allNode.x());
                     var mini_entity = mini_stage.find('#'+evt.target._id+'');
                     mini_entity.x(evt.target.x()*0.048);
                     mini_entity.y(evt.target.y()*0.048);
                     mini_layer.draw();
                     }
             }); // move end
        }
        //entity 생성 종료
     temp_arrow_layer = new Konva.Layer();
        relationLine_layer = new Konva.Layer();
        var relationSwitchFlag = true;
        
        
    
        //전역변수로 빼기
        var old_entity;
        
        //스테이지 클릭
        function stageClick(e){
            console.log('스테이지 클릭');
            
            
            
            
            if(e === 0){
                allNode = stage;
            }else if(e != null){
                allNode = e.target;
            }else{
                allNode = entity.findOne('.entity_logical_txt');
            }
            
            
            //이동버튼 클릭시
                if(allNode.name().indexOf('attr_btn_move') > -1){
                    return;
                    
                    //return;
                }
            
            

            var old_container = entity_container;
            old_entity = entity;
            var old_btn_pk_add = btn_pk_add;
            var old_btn_col_add = btn_col_add;
            var old_btn_entity_delete = btn_entity_delete;
            var old_btn_color = btn_color;
            var old_btn_entity_group = btn_entity_group;
            
            //입력창 삭제
           if(document.body.getElementsByClassName('attrInput').length > 0){
               document.body.removeChild(inputss);
           }
            
            /////yhs
           if(allNode.parent === null || temp_arrow != null ){  // 좀 더 생각해보자 temp_arrow != null말고 e.를 활용해서 
               console.log('temp_arrow'+ temp_arrow);
               console.log('allNode'+ allNode);
               old_btn_entity_group.hide();
               old_entity.draggable(false);
               old_container.strokeWidth(0);
               
               if(temp_arrow != null ){ //빈스테이지를 찍어 temp_arrow를 제거해주는 것.
               	
               	//객체 클릭 했을 때
                   if(allNode.findAncestor('.entity')){
                  	console.log('객체 선택');
                  	
                  	$('html').css({'cursor':'default'});
                  	
                  	//identifying을 물어보는 창 생성
                  	$('.identify_hs').css('display','table');
                  	
                  	//새로운 화살표 생성 단  relationType가 true/false인지 확인해야람 identifying인지 non-identify인지
                  
                  	secondEntity = allNode.findAncestor('.entity');
                  	
                  }
               	
               	//빈 스테이지 클릭했을 때.
               	stage.off('mousemove');
               	temp_arrow.remove();
               	temp_arrow_layer.draw();
               	isRRelationClick=false;
               	temp_arrow=null;
               }
           }
            
            
            
            
            ///yhs
           if(allNode.parent === null || temp_arrow != null ){  // 좀 더 생각해보자 temp_arrow != null말고 e.를 활용해서 
               console.log('temp_arrow'+ temp_arrow);
               console.log('allNode'+ allNode);
               old_btn_entity_group.hide();
               old_entity.draggable(false);
               old_container.strokeWidth(0);
               
               if(temp_arrow != null ){ //빈스테이지를 찍어 temp_arrow를 제거해주는 것.
               	
               	//객체 클릭 했을 때
                   if(allNode.findAncestor('.entity')){
                  	console.log('객체 선택');
                  	
                  	//identifying을 물어보는 창 생성
                  	$('.identify_hs').css('display','block');
                  	
                  	//새로운 화살표 생성 단  relationType가 true/false인지 확인해야람 identifying인지 non-identify인지
                  
                  	secondEntity = allNode.findAncestor('.entity');
                  	
                  }
               	
               	//빈 스테이지 클릭했을 때.
               	stage.off('mousemove');
               	temp_arrow.remove();
               	temp_arrow_layer.draw();
               	isRRelationClick=false;
               	temp_arrow=null;
               }
           }
            
            
            
            
        /*     //스테이지 클릭시
            if(allNode.parent === null){
                console.log("스테이지 선택");
                
                old_btn_entity_group.hide();
                
                old_entity.draggable(false);
                old_container.strokeWidth(0);
                
            } */
            
            
            
            //객체 선택시
            else {
                
                //변수에 클릭 타겟 넣기
                entity = allNode.findAncestor('.entity');
                
 
                //entity 삭제버튼 이벤트 
                if(allNode.name().indexOf('btn_entity_delete') > -1){
                    
                    var removeTableNo=allNode.findAncestor('.entity')._id;
                    console.log('삭제할번호'+ removeTableNo);
                    
                    mini_stage.find('#'+removeTableNo+'').remove(); //미니맵 테이블 삭제
                    
                    allNode.findAncestor('.entity').remove();
                    mini_layer.draw();
                    layer.draw();
                    return;
                }
                
                
                //pk버튼 이벤트
                if(allNode.name().indexOf('btn_pk_add') > -1){
                    fn_attributeAdd("pk_group",entity);
                    //return;
                }
                
                //attr버튼 이벤트
                if(allNode.name().indexOf('btn_col_add') > -1){
                    fn_attributeAdd("attr_group",entity);
                    //return;
                }
                
                //fk 테스트
                if(allNode.name().indexOf('btn_color') > -1){
                    fn_attributeAdd("fk_group",entity);
                    
                    //return;
                }
                
                
                
                
     
                
                //속성 삭제 버튼 테스트
                if(allNode.name().indexOf('attr_btn_remove') > -1){
         
                    allNode.findAncestor('.attribute').destroy();
     
                }
                
                
                
                
                entity_container = entity.findOne('.entity_container');
                entity_logical = entity.findOne('.entity_logical');
                entity_phisical = entity.findOne('.entity_phisical');
                entity_logical_txt = entity.findOne('.entity_logical_txt');
                entity_phisical_txt = entity.findOne('.entity_phisical_txt');
                
                btn_entity_group = entity.findOne('.btn_entity_group');
                
                btn_entity_delete = btn_entity_group.findOne('.btn_entity_delete');
                btn_entity_delete_txt = btn_entity_group.findOne('.btn_entity_delete_txt');
                
                btn_color = btn_entity_group.findOne('.btn_color');
                btn_color_txt = btn_entity_group.findOne('.btn_color_txt');
                
                btn_pk_add = btn_entity_group.findOne('.btn_pk_add');
                btn_pk_add_txt = btn_entity_group.findOne('.btn_pk_add_txt');
                
                btn_col_add = btn_entity_group.findOne('.btn_col_add');
                btn_col_add_txt = btn_entity_group.findOne('.btn_col_add_txt');

                
                
                //로직 시작
                entity.moveTo(layer2);
       
                old_btn_entity_group.hide();
                
                old_entity.draggable(false);
                old_container.strokeWidth(0);
 
                btn_entity_group.show();
                
                entity.draggable(true);
                
                entity_container.strokeWidth(BORDER_SIZE);
                
                entity.moveTo(layer);
                
                
                console.log('makeArrow');
                makeArrow(e);
            }
            
            //리사이징 시작
            entity_resize();
            
            
            
            //미니맵에 객체 갱신
             var mini_entity = mini_stage.find('#'+entity._id+'');
             mini_entity.width(entity.children[0].width()*0.048);
             mini_entity.height(entity.children[0].height()*0.048);
             mini_layer.draw();
            
            
            
            layer.draw();
        }
        
    
    
    
    
//        텍스트 값 입력 메소드
        var inputss = document.createElement('input');
        
        function textClick(e){
            
            console.log("double click!!!");
            
            textNode = e.target;
            
            if(textNode.className != "Text" || textNode.name().indexOf('btn') > -1){
                return;
            }
            
            
            console.log(textNode.text());
            var textPosition = textNode.getAbsolutePosition();


            var stageBox = stage.container().getBoundingClientRect();


            var areaPosition = {
              x: stageBox.left + textPosition.x,
              y: stageBox.top + textPosition.y
            };


			console.log((textNode.width()*stage.scale().x)+3);
            document.body.appendChild(inputss);
            $(inputss).addClass('attrInput');
            inputss.value = textNode.text();
            inputss.style.position = 'absolute';
            inputss.style.top = (areaPosition.y) + 'px';	/* (areaPosition.y-(stage.scale().x+1)) + 'px'; */
            inputss.style.left = (areaPosition.x) + 'px';
            inputss.style.width = (textNode.width()-6)*stage.scale().x + 'px';
            inputss.style.height = (textNode.height()-3)*stage.scale().y + 'px';
            inputss.style.fontSize = textNode.fontSize()*stage.scale().x + 'px';
            inputss.style.paddingLeft = (5*stage.scale().x)+'px';
            
            inputss.style.background = textNode.findAncestor('.entity').findOne('.entity_container').attrs.fill;
            inputss.style.color = textNode.findAncestor('.entity').findOne('.entity_container').attrs.stroke;
            inputss.style.border = '0px';
            inputss.style.fontFamily = textNode.fontFamily();
           
//             inputss.style.border = (2*stage.scale().x)+'px solid #000';

            inputss.focus();

            inputss.addEventListener('keydown', enterK);
    
        }
       
        
        
        
        
        
        
        
        //엔터입력
        function enterK(e){
             if (e.keyCode === 13) {
                //텍스트 입력 값 적용
                 textNode.text(inputss.value);
                 
  
                 //텍스트 미입력시 최소값 설정
                 if(textNode.width() < 40){
                     textNode.textWidth = 30;
                 }
                 
                 
                 //플레이스홀더 설정
                 if(textNode.findAncestor('.attr_groups') != null){
                    if(textNode.text() === "" && textNode.findAncestor('.attr_groups').findOne('.placeHolder') != null ){
                         textNode.findAncestor('.attr_groups').findOne('.placeHolder').visible(true);
                     }else if(textNode.findAncestor('.attr_groups').findOne('.placeHolder') != null){
                         textNode.findAncestor('.attr_groups').findOne('.placeHolder').visible(false);
                     } 
                 }
                    

                 
                 

                 
                 
                 
                //변수에 클릭 타겟 넣기
                entity = allNode.findAncestor('.entity');

                entity_container = entity.findOne('.entity_container');
                entity_logical = entity.findOne('.entity_logical');
                entity_phisical = entity.findOne('.entity_phisical');
                entity_logical_txt = entity.findOne('.entity_logical_txt');
                entity_phisical_txt = entity.findOne('.entity_phisical_txt');
                
                btn_entity_group = entity.findOne('.btn_entity_group');
                
                btn_entity_delete = btn_entity_group.findOne('.btn_entity_delete');
                btn_entity_delete_txt = btn_entity_group.findOne('.btn_entity_delete_txt');
                
                btn_color = btn_entity_group.findOne('.btn_color');
                btn_color_txt = btn_entity_group.findOne('.btn_color_txt');
                
                btn_pk_add = btn_entity_group.findOne('.btn_pk_add');
                btn_pk_add_txt = btn_entity_group.findOne('.btn_pk_add_txt');
                
                btn_col_add = btn_entity_group.findOne('.btn_col_add');
                btn_col_add_txt = btn_entity_group.findOne('.btn_col_add_txt');
 
                 
                 
                //리사이징 시작
                entity_resize();
                 
                 
                //미니맵에 객체 갱신
                 var mini_entity = mini_stage.find('#'+entity._id+'');
                 mini_entity.width(entity.children[0].width()*0.048);
                 mini_entity.height(entity.children[0].height()*0.048);
                 
                 mini_layer.draw(); 
                layer.draw();
                 
                document.body.removeChild(inputss);
                //this.removeEventListener('keydown',arguments.callee);
                console.log("엔터입력 완료");
              }
        }
        
        
      
        
        var reszie_entity_container;
        
        //리사이징
        
        function entity_resize(){
            
//           1. entity(테이블 리사이징)
             entity_logical.width(entity_logical_txt.width());
             
             entity_phisical.x(entity_logical.width()+BORDER_SIZE);
             entity_phisical_txt.x(entity_phisical.x());
             entity_phisical.width(entity_phisical_txt.width()); 
             
           
           reszie_entity_container = entity_logical_txt.width()+entity_phisical_txt.width()+(BORDER_SIZE*2);
            
               
               
//               entity_container.width(entity_logical_txt.width()+entity_phisical_txt.width()+(BORDER_SIZE*2));
  
            
//          2. attribute(속성 리사이징)
            resize2(entity);
            
            
            
            
//          3. entity(테이블 논리, 물리 위치)
            entity_phisical.x(entity_container.width()-entity_phisical.width()-BORDER_SIZE);
            entity_phisical_txt.x(entity_phisical.x());
            
//          4. entity 기능 버튼 위치(pk,attr, 색상변경, 삭제 버튼 등등...)
            btn_entity_delete.x(entity_container.width() -(20-(BORDER_SIZE-1)));
            btn_color.x(btn_entity_delete.x() - 21);
            btn_entity_delete_txt.x(btn_entity_delete.x()+7);
            btn_color_txt.x(btn_color.x()+7);
            
            
 
        }
  
        
        
        //스크롤 확대 축소
        var SCALE_MIN = 0.45;
        var SCALE_MAX = 1.8;
        var scaleBy = 1.05;
        stage.on('wheel', e => {
                
                e.evt.preventDefault();
                var oldScale = stage.scaleX();
				console.log('stage.scaleX()'+ stage.scaleX());
				
			
            
            
            
                //미니맵 관련
                var screenWidth = $('#container_Shin').width();
                var screenHeight = $('#container_Shin').height();
            
                var plusWidth = ((screenWidth)*0.048)/(stage.scale().x);
                var plusHeight = ((screenHeight)*0.048)/(stage.scale().y);
            
                mini_rect.width(plusWidth);
                mini_rect.height(plusHeight);
            
                mini_rect.x((-stage.x() * 0.048)/stage.scaleX());
		        mini_rect.y((-stage.y() * 0.048)/stage.scaleY());
             
                collision_check_mini();
            
                mini_layer.draw();//돋보기창
                //미니맵 관련 종료
            
				
                var mousePointTo = {
                  x: stage.getPointerPosition().x / oldScale - stage.x() / oldScale,
                  y: stage.getPointerPosition().y / oldScale - stage.y() / oldScale
                };
                
            
                //최소, 최대 스케일 추가
                var newScale
                if(stage.scaleX() <= SCALE_MIN){
                    
                    newScale = e.evt.deltaY > 0 ? oldScale * scaleBy : oldScale;
                    
                }else if(stage.scaleX() >= SCALE_MAX){
                    
                    newScale = e.evt.deltaY > 0 ? oldScale : oldScale / scaleBy;
                    
                }else{    
                    
                    newScale = e.evt.deltaY > 0 ? oldScale * scaleBy : oldScale / scaleBy;
                    
                }
    
                    
                stage.scale({ x: newScale, y: newScale });

                var newPos = {
                  x:
                    -(mousePointTo.x - stage.getPointerPosition().x / newScale) *
                    newScale,
                  y:
                    -(mousePointTo.y - stage.getPointerPosition().y / newScale) *
                    newScale
                };
            
  

                stage.position(newPos);
                stage.batchDraw();
                console.log(stage.scale().x);
            
        
      });
    

        
</script>

</html>


