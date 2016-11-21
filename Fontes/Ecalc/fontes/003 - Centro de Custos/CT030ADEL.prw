#INCLUDE 'TOTVS.CH'

user function CT030ADEL()

	Local nOpc    := PARAMIXB

	ApMsgStop ( 'Atenção !!!', 'Não é Permitido Excluir Centro de Custo !!!' )

return .F.