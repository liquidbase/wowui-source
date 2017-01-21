
---------------
--NOTE - Please do not change this section without talking to Dan
local _, tbl = ...;
if tbl then
	tbl.SecureCapsuleGet = SecureCapsuleGet;

	local function Import(name)
		tbl[name] = tbl.SecureCapsuleGet(name);
	end

	Import("IsOnGlueScreen");

	if ( tbl.IsOnGlueScreen() ) then
		tbl._G = _G;	--Allow us to explicitly access the global environment at the glue screens
	end

	setfenv(1, tbl);
	
	Import("C_ModelInfo");
	Import("math");
	Import("Lerp");
end
---------------

ModelSceneActorMixin = {};

-- "public" methods
function ModelSceneActorMixin:ApplyFromModelSceneActorInfo(actorInfo)
	self:SetUseCenterForOrigin(actorInfo.useCenterForOriginX, actorInfo.useCenterForOriginY, actorInfo.useCenterForOriginZ);

	self:SetPosition(actorInfo.position:GetXYZ());
	self:SetYaw(actorInfo.yaw);
	self:SetPitch(actorInfo.pitch);
	self:SetRoll(actorInfo.roll);

	self.requestedScale = nil;

	local animation, animationVariation, alpha, scale;
	if actorInfo.modelActorDisplayID then
		animation, animationVariation, alpha, scale = C_ModelInfo.GetModelSceneActorDisplayInfoByID(actorInfo.modelActorDisplayID);
	end

	self:SetAnimation(animation or 0, animationVariation);
	self:SetAlpha(alpha or 1.0);
	self:SetRequestedScale(scale or 1.0);

	self:SetNormalizedScaleAggressiveness(actorInfo.normalizeScaleAggressiveness or 0.0);

	self:MarkScaleDirty();
	self:UpdateScale();
end

function ModelSceneActorMixin:SetNormalizedScaleAggressiveness(normalizedScaleAggressiveness)
	if self.normalizedScaleAggressiveness ~= normalizedScaleAggressiveness then
		self.normalizedScaleAggressiveness = normalizedScaleAggressiveness;
		self:MarkScaleDirty();
	end
end

function ModelSceneActorMixin:GetNormalizedScaleAggressiveness()
	return self.normalizedScaleAggressiveness;
end

function ModelSceneActorMixin:SetRequestedScale(requestedScale)
	if self.requestedScale ~= requestedScale then
		self.requestedScale = requestedScale;
		self:MarkScaleDirty();
	end
end

function ModelSceneActorMixin:GetRequestedScale()
	return self.requestedScale or self:GetScale();
end

MODEL_SCENE_ACTOR_DIMENSIONS_FOR_NORMALIZATION = { width = .9984, depth = 1.121, height = 2.118 }; -- Roughly the dimensions of a human male model (but why male models?)
function ModelSceneActorMixin:CalculateNormalizedScale(normalizedScaleAggressiveness)
	if self:IsLoaded() and normalizedScaleAggressiveness > 0.0 then
		local bottomX, bottomY, bottomZ, topX, topY, topZ = self:GetActiveBoundingBox(); -- Could be nil for invisible models
		if bottomX and bottomY and bottomZ and topX and topY and topZ then
			local width = topX - bottomX;
			local depth = topY - bottomY;
			local height = topZ - bottomZ;

			local widthScale = width / MODEL_SCENE_ACTOR_DIMENSIONS_FOR_NORMALIZATION.width;
			local depthScale = depth / MODEL_SCENE_ACTOR_DIMENSIONS_FOR_NORMALIZATION.depth;
			local heightScale = height / MODEL_SCENE_ACTOR_DIMENSIONS_FOR_NORMALIZATION.height;

			local maxScale = math.max(widthScale, math.max(depthScale, heightScale));
			if maxScale == 0 then
				return 1.0;
			end

			return 1 / Lerp(1.0, maxScale, normalizedScaleAggressiveness);
		end
	end

	return 1.0;
end

-- "private" methods
function ModelSceneActorMixin:OnUpdate()
	self:UpdateScale();
end

function ModelSceneActorMixin:OnModelLoaded()
	self:MarkScaleDirty();
end

function ModelSceneActorMixin:UpdateScale()
	if self.scaleDirty and self:IsLoaded() then
		self.scaleDirty = nil;
		local effectiveScale = self:GetRequestedScale() * self:CalculateNormalizedScale(self:GetNormalizedScaleAggressiveness());
		self:SetScale(effectiveScale);
	end
end

function ModelSceneActorMixin:MarkScaleDirty()
	self.scaleDirty = true;
end