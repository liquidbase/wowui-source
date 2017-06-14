
NamePlateCommentatorDisplayInfoMixin = {};

function NamePlateCommentatorDisplayInfoMixin:OnUpdate()
	local CCIndicator = self.CCIndicator;
	local spellID, expirationTime, duration = C_Commentator.GetPlayerCrowdControlInfoByUnit(self:GetParent().unit);
	local iconTexture = select(3, GetSpellInfo(spellID));
	if iconTexture then
		CCIndicator.icon:SetTexture(iconTexture);
		CCIndicator.icon:Show();
	else
		CCIndicator.icon:Hide();
	end
	
	if expirationTime then
		CooldownFrame_Set(CCIndicator.Cooldown, expirationTime - duration, duration, true, true);
	else
		CooldownFrame_Clear(CCIndicator.Cooldown);
	end
	
	local offensiveActive, defensiveActive = C_Commentator.HasTrackedAuras(self:GetParent().unit);
	self.OffensiveCooldownModel:SetShown(offensiveActive);
	self.DefensiveCooldownModel:SetShown(defensiveActive);
end