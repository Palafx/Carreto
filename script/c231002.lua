--Diablillo de la Canción
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon it from the hand if you control a Tuner monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--special summon 1 token if used as synchro material
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.stcon)
	e2:SetTarget(s.sttg)
	e2:SetOperation(s.stop)
	c:RegisterEffect(e2)
	--hand synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetLabel(id)
	e3:SetValue(s.synval)
	c:RegisterEffect(e3)
end
--add
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,TYPE_TUNER),tp,LOCATION_MZONE,0,1,nil)
end
--token
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:IsRace(RACE_FIEND) and r & REASON_SYNCHRO == REASON_SYNCHRO
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
			Duel.IsPlayerCanSpecialSummonMonster(tp,231099,0x231,TYPES_TOKEN+TYPE_TUNER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
			Duel.IsPlayerCanSpecialSummonMonster(tp,231099,0x231,TYPES_TOKEN+TYPE_TUNER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,231099)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--extra material
function s.synval(e,c,sc)
	if sc:IsRace(RACE_FIEND) and --c:IsNotTuner() 
		(not c:IsType(TYPE_TUNER) or c:IsHasEffect(EFFECT_NONTUNER)) and c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(id)
		e1:SetTarget(s.synchktg)
		c:RegisterEffect(e1)
		return true
	else return false end
end
function s.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==id then return true end
	end
	return false
end
function s.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=tg:IsExists(s.chk2,1,c) or ntg:IsExists(s.chk2,1,c) or sg:IsExists(s.chk2,1,c)
		return res,Group.CreateGroup(),Group.CreateGroup()
	else
		return true
	end
end