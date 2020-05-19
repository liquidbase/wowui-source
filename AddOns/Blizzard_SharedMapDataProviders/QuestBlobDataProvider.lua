
QuestBlobDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin);

function QuestBlobDataProviderMixin:SetShowWorldQuests(showWorldQuests)
	self.showWorldQuests = showWorldQuests;
	if self.pin then
		self.pin:Refresh();
	end
end

function QuestBlobDataProviderMixin:IsShowingWorldQuests()
	return not not self.showWorldQuests;
end

function QuestBlobDataProviderMixin:OnAdded(mapCanvas)
	MapCanvasDataProviderMixin.OnAdded(self, mapCanvas);
	self:GetMap():SetPinTemplateType("QuestBlobPinTemplate", "QuestPOIFrame");

	-- a single permanent pin
	local pin = self:GetMap():AcquirePin("QuestBlobPinTemplate");
	pin.dataProvider = self;
	pin:SetPosition(0.5, 0.5);
	self.pin = pin;

	if not self.setHighlightedQuestIDCallback then
		self.setHighlightedQuestIDCallback = function(event, ...) self.pin:SetHighlightedQuestID(...); end;
	end
	if not self.clearHighlightedQuestIDCallback then
		self.clearHighlightedQuestIDCallback = function(event, ...) self.pin:ClearHighlightedQuestID(...); end;
	end
	if not self.setFocusedQuestIDCallback then
		self.setFocusedQuestIDCallback = function(event, ...) self.pin:SetFocusedQuestID(...); end;
	end
	if not self.clearFocusedQuestIDCallback then
		self.clearFocusedQuestIDCallback = function(event, ...) self.pin:ClearFocusedQuestID(...); end;
	end
	if not self.setHighlightedQuestPOICallback then
		self.setHighlightedQuestPOICallback = function(event, ...) self.pin:SetHighlightedQuestPOI(...); end;
	end
	if not self.clearHighlightedQuestPOICallback then
		self.clearHighlightedQuestPOICallback = function(event, ...) self.pin:ClearHighlightedQuestPOI(...); end;
	end
	self:GetMap():RegisterCallback("SetHighlightedQuestID", self.setHighlightedQuestIDCallback);
	self:GetMap():RegisterCallback("ClearHighlightedQuestID", self.clearHighlightedQuestIDCallback);
	self:GetMap():RegisterCallback("SetFocusedQuestID", self.setFocusedQuestIDCallback);
	self:GetMap():RegisterCallback("ClearFocusedQuestID", self.clearFocusedQuestIDCallback);
	self:GetMap():RegisterCallback("SetHighlightedQuestPOI", self.setHighlightedQuestPOICallback);
	self:GetMap():RegisterCallback("ClearHighlightedQuestPOI", self.clearHighlightedQuestPOICallback);
end

function QuestBlobDataProviderMixin:OnRemoved(mapCanvas)
	self:GetMap():UnregisterCallback("SetHighlightedQuestID", self.setHighlightedQuestIDCallback);
	self:GetMap():UnregisterCallback("ClearHighlightedQuestID", self.clearHighlightedQuestIDCallback);
	self:GetMap():UnregisterCallback("SetFocusedQuestID", self.setFocusedQuestIDCallback);
	self:GetMap():UnregisterCallback("ClearFocusedQuestID", self.clearFocusedQuestIDCallback);
	self:GetMap():UnregisterCallback("SetHighlightedQuestPOI", self.setHighlightedQuestPOICallback);
	self:GetMap():UnregisterCallback("ClearHighlightedQuestPOI", self.clearHighlightedQuestPOICallback);

	MapCanvasDataProviderMixin.OnRemoved(self, mapCanvas);
end

function QuestBlobDataProviderMixin:OnMapChanged()
	self.pin:OnMapChanged();
end

--[[ Quest Blob Pin ]]--
QuestBlobPinMixin = CreateFromMixins(MapCanvasPinMixin);

function QuestBlobPinMixin:OnLoad()
	self:SetFillTexture("Interface\\WorldMap\\UI-QuestBlob-Inside");
	self:SetBorderTexture("Interface\\WorldMap\\UI-QuestBlob-Outside");
	self:SetFillAlpha(128);
	self:SetBorderAlpha(192);
	self:SetBorderScalar(1.0);
	self:SetIgnoreGlobalPinScale(true);
	self:UseFrameLevelType("PIN_FRAME_LEVEL_QUEST_BLOB");
	self.questID = 0;
end

function QuestBlobPinMixin:OnShow()
	self:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED");
	self:SetQuestID(GetSuperTrackedQuestID());
end

function QuestBlobPinMixin:OnHide()
	self:UnregisterEvent("SUPER_TRACKED_QUEST_CHANGED");
end

function QuestBlobPinMixin:OnEvent(event, ...)
	if event == "SUPER_TRACKED_QUEST_CHANGED" then
		self:SetQuestID(GetSuperTrackedQuestID());
	end
end

function QuestBlobPinMixin:OnCanvasSizeChanged()
	self:SetSize(self:GetMap():DenormalizeHorizontalSize(1.0), self:GetMap():DenormalizeVerticalSize(1.0));
end

function QuestBlobPinMixin:OnCanvasScaleChanged()
	-- need to wait until end of the frame to update
	self:MarkDirty();
end

function QuestBlobPinMixin:MarkDirty()
	self.dirty = true;
end

function QuestBlobPinMixin:SetQuestID(questID)
	self.questID = questID;
	self:Refresh();
end

function QuestBlobPinMixin:OnUpdate()
	if self.dirty then
		self.dirty = nil;
		self:Refresh();
	end

	self:UpdateTooltip();
end

function QuestBlobPinMixin:TryDrawQuest(questID)
	if questID and questID > 0 and (self.dataProvider:IsShowingWorldQuests() or not QuestUtils_IsQuestWorldQuest(questID)) and (C_QuestLog.IsThreatQuest(questID) or not QuestUtils_IsQuestBonusObjective(questID)) then
		self:DrawBlob(questID, true);
	end
end

function QuestBlobPinMixin:Refresh()
	self:DrawNone();
	if not self.mapAllowsBlobs or not GetCVarBool("questPOI") then
		return;
	end

	self:TryDrawQuest(self.questID);
	self:TryDrawQuest(self.highlightedQuestID);
	self:TryDrawQuest(self.focusedQuestID);
end

function QuestBlobPinMixin:OnMapChanged()
	local mapID = self:GetMap():GetMapID();
	local mapInfo = C_Map.GetMapInfo(mapID);
	self.mapAllowsBlobs = MapUtil.ShouldMapTypeShowQuests(mapInfo.mapType);
	self:SetMapID(mapID);
	self:Refresh();
end

function QuestBlobPinMixin:SetHighlightedQuestID(questID)
	self.highlightedQuestID = questID;
	self:Refresh();
end

function QuestBlobPinMixin:ClearHighlightedQuestID()
	self.highlightedQuestID = nil;
	self:Refresh();
end

function QuestBlobPinMixin:SetFocusedQuestID(questID)
	self.focusedQuestID = questID;
	self:Refresh();
end

function QuestBlobPinMixin:ClearFocusedQuestID()
	self.focusedQuestID = nil;
	self:Refresh();
end

function QuestBlobPinMixin:SetHighlightedQuestPOI(questID)
	self.highlightedQuestPOI = questID;
	self:Refresh();
end

function QuestBlobPinMixin:ClearHighlightedQuestPOI()
	self.highlightedQuestPOI = nil;
	self:Refresh();
end

function QuestBlobPinMixin:UpdateTooltip()
	if self.highlightedQuestPOI then
		return;
	end

	local mouseX, mouseY = self:GetMap():GetNormalizedCursorPosition();
	local questLogIndex, numPOITooltips = self:UpdateMouseOverTooltip(mouseX, mouseY);
	if not questLogIndex then
		self:OnMouseLeave();
		return;
	end
	
	local gameTooltipOwner = GameTooltip:GetOwner();
	if gameTooltipOwner and gameTooltipOwner ~= self then
		return;
	end

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT", 5, 2);

	local title, _, _, _, _, _, _, questID = GetQuestLogTitle(questLogIndex);
	local numObjectives = GetNumQuestLeaderBoards(questLogIndex);
	self.questID = questID;
	self.numObjectives = numObjectives;

	if C_QuestLog.IsThreatQuest(questID) then
		local skipSetOwner = true;
		TaskPOI_OnEnter(self, skipSetOwner);
		return;
	end

	GameTooltip:SetText(title);
	QuestUtils_AddQuestTypeToTooltip(GameTooltip, questID, NORMAL_FONT_COLOR);

	for i = 1, numObjectives do
		local text, objectiveType, finished;

		if numPOITooltips == numObjectives then
			local questPOIIndex = self:GetTooltipIndex(i);
			text, objectiveType, finished = GetQuestPOILeaderBoard(questPOIIndex, questLogIndex);
		else
			text, objectiveType, finished = GetQuestLogLeaderBoard(i, questLogIndex);
		end

		if text and not finished then
			GameTooltip:AddLine(QUEST_DASH..text, 1, 1, 1, true);
		end
	end
	GameTooltip:Show();
end

function QuestBlobPinMixin:OnMouseEnter()
	self:UpdateTooltip();
end

function QuestBlobPinMixin:OnMouseLeave()
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide();
	end
end