CREATE FUNCTION [dbo].[MainMenu2]
(
    @UserId INT,
    @UserRoleID INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    Declare @MenuHTML NVARCHAR(Max)
    
    ---------------------
    SET @MenuHTML='<ul class="metismenu" id="menu" >'
    
    
    DECLARE @MainCount INT
	DECLARE @MainStartIndex INT
	DECLARE @MainMenuName NVARCHAR(MAX)
	DECLARE @MainURL NVARCHAR(MAX)
	DECLARE @ParantId INT
	DECLARE @SL nvarchar(max)
	DECLARE @Class NVARCHAR(MAX)
	DECLARE @Icon NVARCHAR(MAX)
	
	SET @MainStartIndex=1
	    
	
		
	SELECT @MainCount=COUNT(*) FROM dbo.tblMainMenuNew where ParantId is null or ParantId='' 
	
	
	DECLARE @Main CURSOR
	IF(@UserId='1')
	
	BEGIN
	
    SET @Main = CURSOR FAST_FORWARD
    FOR
	SELECT ROW,ManuName,URL,Class,Icon,ParantId,SL FROM (select (ROW_NUMBER() OVER (ORDER BY dbo.tblMainMenuNew.SL)) AS ROW,ISNULL(ManuName,'') AS ManuName,   ISNULL(URL,'')   AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,SL FROM dbo.tblMainMenuNew where TypeId=1 ) AS TblTemp where ParantId is null or ParantId='' order by SL ASC
	END
	ELSE
	BEGIN
	
    SET @Main = CURSOR FAST_FORWARD
    FOR
	select '1',ManuName,URL,Class,Icon,ParantId,dbo.tblMainMenuNew.SL from tblMainMenuNew 
                                      
                                     WHERE   SL in (select ParantId from tblMenuRole
									 left join tblMainMenuNew on tblMenuRole.SL=tblMainMenuNew.SL
									  where RoleId=@UserRoleID  and TypeId=1) order by tblMainMenuNew.SL asc
	
	END
	
	OPEN @Main
    FETCH NEXT FROM @Main
    INTO @MainStartIndex,@MainMenuName,@MainURL,@Class,@Icon,@ParantId,@SL
    
    WHILE @@FETCH_STATUS=0
    
    BEGIN
    
		SET @MenuHTML=@MenuHTML+
		---'<li class="submenu_trigger">'+
		'<li>'+
			'<a href="javascript:;" class="has-arrow">
			'+'<div class="parent-icon"><i class="'+@Icon+'"></i></div>'+
				'<div class="menu-title">'+@MainMenuName+'</div></a>'
				
				
				--<i class="fas fa-sort-down"></i>
				
				
				DECLARE @SubCount INT=0
				DECLARE @SubStartIndex INT
				DECLARE @SubMenuName NVARCHAR(MAX)
				DECLARE @SubURL NVARCHAR(MAX)
				DECLARE @SubParantId INT
				DECLARE @SubSL INT
				DECLARE @SubClass NVARCHAR(MAX)
				DECLARE @SubIcon NVARCHAR(MAX)
		
				IF(@UserId<>'1')
				BEGIN
				SELECT @SubCount=COUNT(DISTINCT tblMainMenuNew.SL) FROM dbo.tblMainMenuNew
			INNER JOIN dbo.tblMenuRole ON dbo.tblMainMenuNew.SL = dbo.tblMenuRole.SL 
                                     WHERE tblMenuRole.RoleId=@UserRoleID  AND ParantId=@SL
				END
				ELSE
				BEGIN
					select @SubCount=COUNT(*) from tblMainMenuNew where ParantId=@SL
				END
				
				IF(@SubCount>0)
				BEGIN
					SET @MenuHTML=@MenuHTML+'<ul>'	
				
				END
				
		
				DECLARE @SubMenu CURSOR
				
				IF(@UserId='1')
				BEGIN
				
				SET @SubMenu = CURSOR FAST_FORWARD
				FOR
				select '1',ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,SL from tblMainMenuNew where ParantId=@SL order by SL asc
				
				
				END
				ELSE
				BEGIN
				
				SET @SubMenu = CURSOR FAST_FORWARD
				FOR
				
				
				SELECT ROW,ManuName,URL,Class,Icon,ParantId,SL FROM 				
								
				(select (ROW_NUMBER() OVER (ORDER BY dbo.tblMainMenuNew.SL)) AS ROW,ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,tblMainMenuNew.SL FROM dbo.tblMainMenuNew
				WHERE ParantId=@SL AND SL IN (SELECT SL FROM dbo.tblMenuRole WHERE RoleId=@UserRoleID) ) AS TblTempa 
				
				END
				
				
				OPEN @SubMenu
				FETCH NEXT FROM @SubMenu
				INTO @SubStartIndex,@SubMenuName,@SubURL,@SubClass,@SubIcon,@SubParantId,@SubSL
							
				WHILE @@FETCH_STATUS=0
				
				BEGIN
					
					DECLARE @IsSub INT=0
					
					SELECT @IsSub=COUNT(*) FROM dbo.tblMainMenuNew WHERE ParantId=@SubSL
					
					IF(@IsSub>0)
					BEGIN
						SET @MenuHTML=@MenuHTML+
						'<li> <a class="has-arrow" href="javascript:;"><i class="'+@SubIcon+'"></i>'+@SubMenuName+'</a>
						'
					---'<li class="submenu_trigger">'+
					
					END
					ELSE
					BEGIN
						SET @MenuHTML=@MenuHTML+
					---'<li class="submenu_trigger">'+
					'<li> <a href="'+@SubURL+'"><i class="'+@SubIcon+'"></i>'+@SubMenuName+'</a>
						'
					
					END
					
					
						
						
				
							
						DECLARE @SubSubCount INT=0
				DECLARE @SubSubStartIndex INT
				DECLARE @SubSubMenuName NVARCHAR(MAX)
				DECLARE @SubSubURL NVARCHAR(MAX)
				DECLARE @SubSubParantId INT
				DECLARE @SubSubSL INT
				DECLARE @SubSubClass NVARCHAR(MAX)
				DECLARE @SubSubIcon NVARCHAR(MAX)
		
				
				IF(@UserId<>'1')
				BEGIN
				SELECT @SubSubCount=COUNT(DISTINCT tblMainMenuNew.SL) from tblMainMenuNew 
                                    INNER JOIN dbo.tblMenuRole ON dbo.tblMainMenuNew.SL = dbo.tblMenuRole.SL 
                                     WHERE tblMenuRole.RoleId=@UserRoleID   AND ParantId=@SubSL 
				END
				ELSE
				BEGIN
					SELECT @SubSubCount=COUNT(*) FROM 				
								
				(select (ROW_NUMBER() OVER (ORDER BY dbo.tblMainMenuNew.SL)) AS ROW,ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,tblMainMenuNew.SL FROM dbo.tblMainMenuNew				
				WHERE  ParantId=@SubSL ) AS TblTempb
				END
				IF(@SubSubCount>0)
				BEGIN
					SET @MenuHTML=@MenuHTML+'<ul>'	
				END
				
				
				
				DECLARE @SubSubMenu CURSOR
				
				IF(@UserId='1')
				BEGIN
				SET @SubSubMenu = CURSOR FAST_FORWARD
				FOR
				
				
				SELECT ROW,ManuName,URL,Class,Icon,ParantId,SL FROM 				
								
				(select (ROW_NUMBER() OVER (ORDER BY dbo.tblMainMenuNew.SL)) AS ROW,ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,tblMainMenuNew.SL FROM dbo.tblMainMenuNew				
				WHERE  ParantId=@SubSL ) AS TblTempb
				
				END
				ELSE
				BEGIN
				SET @SubSubMenu = CURSOR FAST_FORWARD
				FOR
				select '1',ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,dbo.tblMainMenuNew.SL from tblMainMenuNew 
                                     WHERE ParantId=@SubSL AND SL IN (SELECT SL FROM dbo.tblMenuRole WHERE RoleId=@UserRoleID) order by tblMainMenuNew.SL asc
				
				END
				
				OPEN @SubSubMenu
				FETCH NEXT FROM @SubSubMenu
				INTO @SubSubStartIndex,@SubSubMenuName,@SubSubURL,@SubSubClass,@SubSubIcon,@SubSubParantId,@SubSubSL
				
				WHILE @@FETCH_STATUS=0
				BEGIN
				
				DECLARE @IsSubSub INT=0
					
					SELECT @IsSubSub=COUNT(*) FROM dbo.tblMainMenuNew WHERE ParantId=@SubSubSL
				
				
				IF(@IsSubSub>0)
				BEGIN
					SET @MenuHTML=@MenuHTML+
					'<li> <a class="has-arrow" href="javascript:;"><i class="'+@SubSubIcon+'"></i>'+@SubSubMenuName+'</a>
						'
					---'<li class="submenu_trigger">'+
					--'<li class="nav-item">'+
					--	'<a href="'+@SubSubURL+'">
					--		<i class="'+@SubSubIcon+'"></i>
					--		<span class="title">'+@SubSubMenuName+'</span></a>'
					--	---'<a href="'+@SubSubURL+'">'+@SubSubMenuName+'</a>'
				END
				ELSE
				BEGIN
					SET @MenuHTML=@MenuHTML+
					'<li> <a href="'+@SubURL+'"><i class="'+@SubSubIcon+'"></i>'+@SubSubMenuName+'</a>'
					---'<li class="submenu_trigger">'+
					--'<li class="nav-item">'+
					--	'<a href="'+@SubSubURL+'">
					--		<i class="'+@SubSubIcon+'"></i>
					--		<span class="title">'+@SubSubMenuName+'</span></a>'
					--	---'<a href="'+@SubSubURL+'">'+@SubSubMenuName+'</a>'
				END
					
					
					
						
				DECLARE @SubSubSubCount INT=0
				DECLARE @SubSubSubStartIndex INT
				DECLARE @SubSubSubMenuName NVARCHAR(MAX)
				DECLARE @SubSubSubURL NVARCHAR(MAX)
				DECLARE @SubSubSubParantId INT
				DECLARE @SubSubSubSL INT
				DECLARE @SubSubSubClass NVARCHAR(MAX)
				DECLARE @SubSubSubIcon NVARCHAR(MAX)
						
				
				IF(@UserId<>'1')
				BEGIN
				SELECT @SubSubSubCount=COUNT(DISTINCT tblMainMenuNew.SL) from tblMainMenuNew 
                                    INNER JOIN dbo.tblMenuDistribution ON dbo.tblMainMenuNew.SL = dbo.tblMenuDistribution.MenuSL 
                                    WHERE UserId=@UserId AND ParantId=@SubSubSL 
				END
				ELSE
				BEGIN
					SELECT @SubSubSubCount=COUNT(*) FROM 				
								
				(select (ROW_NUMBER() OVER (ORDER BY dbo.tblMainMenuNew.SL)) AS ROW,ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,tblMainMenuNew.SL FROM dbo.tblMainMenuNew				
				WHERE  ParantId=@SubSubSL ) AS TblTempb
				END
				IF(@SubSubSubCount>0)
				BEGIN
					SET @MenuHTML=@MenuHTML+'<ul>'	
				END		
				
				
				DECLARE @SubSubSubMenu CURSOR
				IF(@UserId='1')
				BEGIN
				SET @SubSubSubMenu = CURSOR FAST_FORWARD
				FOR
				
				
				SELECT ROW,ManuName,URL,Class,Icon,ParantId,SL FROM 				
								
				(select (ROW_NUMBER() OVER (ORDER BY dbo.tblMainMenuNew.SL)) AS ROW,ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,tblMainMenuNew.SL FROM dbo.tblMainMenuNew				
				WHERE  ParantId=@SubSubSL ) AS TblTempb
				
				END
				ELSE
				BEGIN
				SET @SubSubSubMenu = CURSOR FAST_FORWARD
				FOR
				select '1',ISNULL(ManuName,'') AS ManuName,ISNULL(URL,'') AS URL,ISNULL(Class,'') AS Class,ISNULL(Icon,'') AS Icon,ISNULL(ParantId,'') AS ParantId,dbo.tblMainMenuNew.SL from tblMainMenuNew 
                                    WHERE ParantId=@SubSubSL AND SL IN (SELECT MenuSL FROM dbo.tblMenuDistribution WHERE UserId=@UserId) order by tblMainMenuNew.SL asc
				
				END
				
				OPEN @SubSubSubMenu
				FETCH NEXT FROM @SubSubSubMenu
				INTO @SubSubSubStartIndex,@SubSubSubMenuName,@SubSubSubURL,@SubSubSubClass,@SubSubSubIcon,@SubSubSubParantId,@SubSubSubSL
						
				WHILE @@FETCH_STATUS=0
				BEGIN
					
					DECLARE @IsSubSubSub INT=0
					
					SELECT @IsSubSubSub=COUNT(*) FROM dbo.tblMainMenuNew WHERE ParantId=@SubSubSubSL
					
					IF(@IsSubSubSub>0)
					BEGIN
						SET @MenuHTML=@MenuHTML+
					
					---'<li class="submenu_trigger">'+
					'<li class="has-sub">'+
					'<a href="'+@SubSubSubURL+'">
							<i class="'+@SubSubSubIcon+'"></i>
							<span class="title">'+@SubSubSubMenuName+'</span></a>'
						--'<a href="'+@SubSubSubURL+'">'+@SubSubSubMenuName+'</a>'
					END		
					
					ELSE
					BEGIN
						SET @MenuHTML=@MenuHTML+
					
					---'<li class="submenu_trigger">'+
					'<li>'+
					'<a href="'+@SubSubSubURL+'">
							<i class="'+@SubSubSubIcon+'"></i>
							<span class="title">'+@SubSubSubMenuName+'</span></a>'
						--'<a href="'+@SubSubSubURL+'">'+@SubSubSubMenuName+'</a>'	
					END
					
						
				FETCH NEXT FROM @SubSubSubMenu
					INTO @SubSubSubStartIndex,@SubSubSubMenuName,@SubSubSubURL,@SubSubSubClass,@SubSubSubIcon,@SubSubSubParantId,@SubSubSubSL
			
				END
			    
			    
				CLOSE @SubSubSubMenu
				DEALLOCATE @SubSubSubMenu
				IF(@SubSubSubCount>0)	
					BEGIN
						SET @MenuHTML=@MenuHTML+'</ul>'	
					END
					
					SET @MenuHTML=@MenuHTML+'</li>'	
				
					FETCH NEXT FROM @SubSubMenu
					INTO @SubSubStartIndex,@SubSubMenuName,@SubSubURL,@SubSubClass,@SubSubIcon,@SubSubParantId,@SubSubSL
			
				END
			    
			    
				CLOSE @SubSubMenu
				DEALLOCATE @SubSubMenu
						
						
					IF(@SubSubCount>0)	
					BEGIN
						SET @MenuHTML=@MenuHTML+'</ul>'	
					END
					
					SET @MenuHTML=@MenuHTML+'</li>'	
				
					FETCH NEXT FROM @SubMenu
					INTO @SubStartIndex,@SubMenuName,@SubURL,@SubClass,@SubIcon,@SubParantId,@SubSL
			
				END
			    
			    
				CLOSE @SubMenu
				DEALLOCATE @SubMenu
				
				IF(@SubCount>0)
				BEGIN
					SET @MenuHTML=@MenuHTML+'</ul>'
				END
			    
			    SET @MenuHTML=@MenuHTML+'</li>'
		
			    
				FETCH NEXT FROM @Main
				INTO @MainStartIndex,@MainMenuName,@MainURL,@Class,@Icon,@ParantId,@SL
			
	END
    
    
    CLOSE @Main
    DEALLOCATE @Main
                       
	
    ---select @MainCount=COUNT(*) from tblMainMenuNew where ParantId is null or ParantId='' order by SL ASC
    
    
	
	SET @MenuHTML=@MenuHTML+'</ul>'    

    RETURN  @MenuHTML

END
