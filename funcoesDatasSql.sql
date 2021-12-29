/*Analise se é feriado*/
CREATE FUNCTION F_ehFeriado(@Data Date)
RETURNS bit
BEGIN 
	IF @Data IN (SELECT CONCAT(ANO_FERIADO, '-', MES_FERIADO, '-', DIA_FERIADO) FROM FERIADO WHERE FIXO = 0)
		RETURN 0
	ELSE IF CONCAT(DATEPART(MONTH, @Data),'-',DATEPART(DAY, @Data)) IN (SELECT CONCAT(MES_FERIADO, '-', DIA_FERIADO) FROM FERIADO WHERE FIXO = 1)
		RETURN 0
	return 1
END


/*Calcula tempestividade entre duas datas*/
CREATE FUNCTION F_RETORNA_TEMPESTIVIDADE(@DataCadastro Date, @DataPublicacao Date)
RETURNS varchar(20)
BEGIN 
	IF @DataCadastro IS NULL OR @DataPublicacao IS NULL 
         BEGIN       
           RETURN '-';
         END
	DECLARE @diasUteis int = 0
	WHILE @DataPublicacao<@DataCadastro
	BEGIN 
          IF DATEPART(WEEKDAY, @DataPublicacao) NOT IN (7,1) AND dbo.F_ehFeriado(@DataPublicacao)=1
            SET @diasUteis += 1;
            SELECT @DataPublicacao = DATEADD(DAY, 1, @DataPublicacao);
    END
    IF @diasUteis <= 2
    	BEGIN
	    	RETURN 'Tempestivo';
    	END
    RETURN 'Intempestivo';
END 
/*teste*/
SELECT dbo.F_RETORNA_TEMPESTIVIDADE('2017-11-29', '2017-11-24');
