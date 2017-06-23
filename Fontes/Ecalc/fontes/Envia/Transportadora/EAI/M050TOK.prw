#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function M050TOK()

	Local oModel  := ModelDef()
	Local lInclui := INCLUI
	Local cCPF    := ''
	Local cCGC    := ''

	If M->A4_XPESSO = 'J'

		cCGC := M->A4_CGC

	Else

		cCPF := M->A4_CGC

	End If

	oModel:SetOperation( 3 )

	oModel:Activate()

	oModel:LoadValue( 'TRANSPORTADORA', 'ID'                 , M->A4_COD    )
	oModel:LoadValue( 'TRANSPORTADORA', 'NOME'               , M->A4_NREDUZ )
	oModel:LoadValue( 'TRANSPORTADORA', 'RAZAOSOCIAL'        , M->A4_NOME   )
	oModel:LoadValue( 'TRANSPORTADORA', 'ATIVO'              , If( M->A4_MSBLQL = '1', 'F', 'T' ) )
	oModel:LoadValue( 'TRANSPORTADORA', 'CPF'                , cCPF )
	oModel:LoadValue( 'TRANSPORTADORA', 'CNPJ'               , cCGC )
	oModel:LoadValue( 'TRANSPORTADORA', 'INSCRICAOMUNICIPAL' , M->A4_XINSMUN )
	oModel:LoadValue( 'TRANSPORTADORA', 'INSCRICAOESTADUAL'  , M->A4_INSEST )
	oModel:LoadValue( 'TRANSPORTADORA', 'ENDERECO'           , M->A4_END )
	oModel:LoadValue( 'TRANSPORTADORA', 'BAIRRO'             , M->A4_BAIRRO )
	oModel:LoadValue( 'TRANSPORTADORA', 'CODMUNICIPIOIBGE'   , M->A4_COD_MUN )
	oModel:LoadValue( 'TRANSPORTADORA', 'ESTADO'             , M->A4_EST )
	oModel:LoadValue( 'TRANSPORTADORA', 'CEP'                , M->A4_CEP )
	oModel:LoadValue( 'TRANSPORTADORA', 'DDD'                , M->A4_DDD )
	oModel:LoadValue( 'TRANSPORTADORA', 'TELEFONE'           , M->A4_TEL )
	oModel:LoadValue( 'TRANSPORTADORA', 'FAX'                , M->A4_XFAX )
	oModel:LoadValue( 'TRANSPORTADORA', 'EMAIL'              , M->A4_EMAIL )


	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

return .T.

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODTRANSPORTADORA')
	Local oStruct := Struct()

	oModel:addFields('TRANSPORTADORA',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Transportadoras')
	oModel:getModel('TRANSPORTADORA'):SetDescription('Cadastro de Transportadoras')
	oModel:GetModel( 'TRANSPORTADORA' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SA4_ECALC',,'SA4_ECALC')

	oStruct:AddField('ID'                 , 'ID'                 , 'ID'                 , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'               , 'NOME'               , 'NOME'               , 'C', 050, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('RAZAOSOCIAL'        , 'RAZAOSOCIAL'        , 'RAZAOSOCIAL'        , 'C', 100, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'              , 'ATIVO'              , 'ATIVO'              , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CPF'                , 'CPF'                , 'CPF'                , 'C', 019, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CNPJ'               , 'CNPJ'               , 'CNPJ'               , 'C', 019, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('INSCRICAOMUNICIPAL' , 'INSCRICAOMUNICIPAL' , 'INSCRICAOMUNICIPAL' , 'C', 015, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('INSCRICAOESTADUAL'  , 'INSCRICAOESTADUAL'  , 'INSCRICAOESTADUAL'  , 'C', 015, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ENDERECO'           , 'ENDERECO'           , 'ENDERECO'           , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('BAIRRO'             , 'BAIRRO'             , 'BAIRRO'             , 'C', 040, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CODMUNICIPIOIBGE'   , 'CODMUNICIPIOIBGE'   , 'CODMUNICIPIOIBGE'   , 'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ESTADO'             , 'ESTADO'             , 'ESTADO'             , 'C', 002, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CEP'                , 'CEP'                , 'CEP'                , 'C', 010, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DDD'                , 'DDD'                , 'DDD'                , 'C', 003, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('TELEFONE'           , 'TELEFONE'           , 'TELEFONE'           , 'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('FAX'                , 'FAX'                , 'FAX'                , 'C', 040, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('EMAIL'              , 'EMAIL'              , 'EMAIL'              , 'C', 250, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct