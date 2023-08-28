--Diablillo Rey de Blanco
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x231),1,3)
	c:EnableReviveLimit()
	
end
s.listed_series={0x231}
