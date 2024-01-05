function Shoot_projectile(who_shot, entity_file, x, y, vel_x, vel_y, to_entity, velocity_multiplier)
	if not velocity_multiplier then velocity_multiplier = 1 end
	local entity_id = EntityLoad(entity_file, x, y)
	local herd = 2
	local genome = EntityGetFirstComponent(who_shot, "GenomeDataComponent")
	if genome then
		herd = ComponentGetValue2(genome, "herd_id")
	else
		local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "ProjectileComponent")
		if comp then
			who_shot = ComponentGetValue2(comp, "mWhoShot")
			herd = ComponentGetValue2(comp, "mShooterHerdId")
		end
	end
    if to_entity then
        vel_x, vel_y = EntityGetTransform(to_entity)
        GameShootProjectile( who_shot, x, y, vel_x, vel_y, entity_id, true, who_shot )
    else
        GameShootProjectile( who_shot, x, y, x+vel_x, y+vel_y, entity_id, true, who_shot )
    end
	local comp = EntityGetFirstComponent(entity_id, "VelocityComponent") or 0
	local vx, vy = ComponentGetValue2(comp, "mVelocity")
	vx = vx * velocity_multiplier
	vy = vy * velocity_multiplier
	ComponentSetValue2(comp, "mVelocity", vx, vy)
	local comps = EntityGetComponent(entity_id, "ProjectileComponent") or {}
	for i = 1, #comps do
		ComponentSetValue2(comps[i], "mShooterHerdId", herd)
		ComponentSetValue2(comps[i], "mWhoShot", who_shot)
	end

	return entity_id
end
