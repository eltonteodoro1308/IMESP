#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

user function MA040TOK()

	Local oModel  := ModelDef()
	Local lInclui := INCLUI
	Local cCPF    := ''
	Local cCGC    := ''

	If M->A3_XPESSO = 'J'

		cCGC := M->A3_CGC

	Else

		cCPF := M->A3_CGC

	End If

	oModel:SetOperation( 3 )

	oModel:Activate()

	oModel:LoadValue( 'VENDEDOR', 'ID'               , M->A3_COD    )
	oModel:LoadValue( 'VENDEDOR', 'NOME'             , M->A3_NREDUZ )
	oModel:LoadValue( 'VENDEDOR', 'RAZAOSOCIAL'      , M->A3_NOME   )
	oModel:LoadValue( 'VENDEDOR', 'ATIVO'            , If( M->A3_MSBLQL = '1', 'F', 'T' ) )
	oModel:LoadValue( 'VENDEDOR', 'CPF'              , cCPF )
	oModel:LoadValue( 'VENDEDOR', 'CNPJ'             , cCGC )
	oModel:LoadValue( 'VENDEDOR', 'ENDERECO'         , M->A3_END )
	oModel:LoadValue( 'VENDEDOR', 'CODMUNICIPIOIBGE' , M->A3_XCD_MUN  )
	oModel:LoadValue( 'VENDEDOR', 'ESTADO'           , M->A3_EST )
	oModel:LoadValue( 'VENDEDOR', 'CEP'              , M->A3_CEP )
	oModel:LoadValue( 'VENDEDOR', 'DDD'              , M->A3_DDDTEL )
	oModel:LoadValue( 'VENDEDOR', 'TELEFONE'         , M->A3_TEL )
	oModel:LoadValue( 'VENDEDOR', 'FAX'              , M->A3_FAX )
	oModel:LoadValue( 'VENDEDOR', 'EMAIL'            , M->A3_EMAIL )
	oModel:LoadValue( 'VENDEDOR', 'COMISSAO'         , AllTrim( Str( M->A3_COMIS ) ) )

	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

return .T.

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODVENDEDOR')
	Local oStruct := Struct()

	oModel:addFields('VENDEDOR',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Vendedores')
	oModel:getModel('VENDEDOR'):SetDescription('Cadastro de Vendedores')
	oModel:GetModel( 'VENDEDOR' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SA3_ECALC',,'SA3_ECALC')

	oStruct:AddField('ID'               , 'ID'               , 'ID'               , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'             , 'NOME'             , 'NOME'             , 'C', 050, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('RAZAOSOCIAL'      , 'RAZAOSOCIAL'      , 'RAZAOSOCIAL'      , 'C', 060, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'            , 'ATIVO'            , 'ATIVO'            , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CPF'              , 'CPF'              , 'CPF'              , 'C', 019, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CNPJ'             , 'CNPJ'             , 'CNPJ'             , 'C', 019, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ENDERECO'         , 'ENDERECO'         , 'ENDERECO'         , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CODMUNICIPIOIBGE' , 'CODMUNICIPIOIBGE' , 'CODMUNICIPIOIBGE' , 'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ESTADO'           , 'ESTADO'           , 'ESTADO'           , 'C', 002, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CEP'              , 'CEP'              , 'CEP'              , 'C', 010, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DDD'              , 'DDD'              , 'DDD'              , 'C', 003, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('TELEFONE'         , 'TELEFONE'         , 'TELEFONE'         , 'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('FAX'              , 'FAX'              , 'FAX'              , 'C', 040, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('EMAIL'            , 'EMAIL'            , 'EMAIL'            , 'C', 250, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('COMISSAO'         , 'COMISSAO'         , 'COMISSAO'         , 'C', 050, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct