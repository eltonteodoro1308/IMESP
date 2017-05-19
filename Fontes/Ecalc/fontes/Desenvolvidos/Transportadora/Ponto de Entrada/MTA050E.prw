#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function MTA050E()

	ApMsgStop ( 'Não é Permitido Excluir Transportadoras !!!', 'Atenção !!!' )

Return .F.