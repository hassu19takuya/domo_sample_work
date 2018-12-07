CREATE PROCEDURE create_employee_skills ()
BEGIN
	-- 一般変数宣言
   DECLARE MAXIMUM_SKILL_NUM INT DEFAULT 0;
   DECLARE CURRENT_SKILL_NUM INT DEFAULT 0;
   DECLARE CURRENT_SKILL_ID INT;
   DECLARE LAST_SKILL_ID INT;
   DECLARE SKILL_LEVEL INT DEFAULT 1;
   DECLARE EXPERIENCE INT DEFAULT 0;
   
   -- カーソル用変数宣言
	DECLARE empID varchar(20);

   -- カーソル終了ハンドラ変数
	-- DECLARE v_done INT DEFAULT 1;
   declare cursor_count_1	int	default 0;

	-- 社員カーソル
	DECLARE emp_curs cursor FOR
   SELECT `連番` FROM `P_人材スキルマップ_社員詳細情報`;
	 
	-- DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET v_done = 0;
   declare continue handler for not found set cursor_count_1 = 1;
   
   OPEN emp_curs;
   
   emp_loop: loop
   fetch emp_curs INTO empID;
 
   -- emp_loop離脱条件確認
   IF cursor_count_1 = 1 then
	LEAVE emp_loop;
   END IF;
 
   -- 変数の初期化
   SET MAXIMUM_SKILL_NUM = 0;
	SET	CURRENT_SKILL_NUM = 0;
	SET	CURRENT_SKILL_ID = 0;
   SET	LAST_SKILL_ID = 0;
   SET	SKILL_LEVEL = 1;
   SET	EXPERIENCE = 0;

  	-- Maxスキル数の設定
  	SET MAXIMUM_SKILL_NUM = FLOOR(RAND() * 10) + 1;

   WHILE CURRENT_SKILL_NUM < MAXIMUM_SKILL_NUM 
   		DO
   
		SET CURRENT_SKILL_NUM = CURRENT_SKILL_NUM + 1;

		-- スキルIDの付与(同じスキルは２度もたない)
      WHILE CURRENT_SKILL_ID = 0 OR CURRENT_SKILL_ID = LAST_SKILL_ID
      		DO
      		SET CURRENT_SKILL_ID = FLOOR(RAND() * 653) + 1;

		END WHILE;
       
      -- スキルレベルの設定
      SET SKILL_LEVEL = FLOOR(RAND() * 5) + 1;
      
      -- 経験年数の設定
      SET EXPERIENCE = FLOOR(RAND() * 11);
      
      -- レコードの挿入
		INSERT INTO skill_list(empID, skillID, skillRank, skillLevel, years) VALUES (empID, LPAD(CURRENT_SKILL_ID, 4, 0), CURRENT_SKILL_NUM, SKILL_LEVEL, EXPERIENCE);
      
      SET LAST_SKILL_ID = CURRENT_SKILL_ID;

	END WHILE;  

	-- fetch emp_curs INTO empID;
	end loop emp_loop;
	CLOSE emp_curs;

END;