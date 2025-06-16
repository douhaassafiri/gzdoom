// A stationary Arachnotron-based turret that tracks the player by sight
// Fires plasma at regular intervals when the player is visible
class TurretArachnotron : Arachnotron replaces Arachnotron
{
    // Cooldown timer between shots (measured in tics)
    int cooldown;

    Default
    {
        +NOGRAVITY
        -LOOKALLAROUND
        -AMBUSH
        +SEEINVISIBLE
        Speed 0;
        RenderStyle "Normal";
        Radius 64;
        Height 64;
        Health 500;
    }

    // Called when the turret spawns into the world
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        vel.X = 0; // No movement
        vel.Y = 0;
        cooldown = 0; // Initialise shot cooldown
    }

    // Runs every frame to check player visibility and fire if ready
    override void Tick()
    {
        super.Tick();

        let info = Players[ConsolePlayer];
        if (info != null && info.mo != null)
        {
            Actor player = info.mo;

            // If turret has line of sight to the player, aim and shoot
            if (CheckSight(player))
            {
                self.target = player;
                // Rotate to face the player
                double dx = player.Pos.X - Pos.X;
                double dy = player.Pos.Y - Pos.Y;
                angle = vectorangle(dx, dy);

                // Fire if cooldown expire
                if (cooldown <= 0)
                {
                    FireAtTarget(player);
                    cooldown = 35 * 2; // 2 second cooldown (70 tics)
                }
            }
        }

        // Decrease cooldown every tick
        if (cooldown > 0)
            cooldown--;
    }

    // Shoots a plasma projectile toward the current target
    void FireAtTarget(Actor target)
    {
        A_FaceTarget();
        A_CustomMissile("ArachnotronPlasma", 32, false, 0, 0);
    }

    States
    {
    Spawn:
        BSPI A 10;
        Loop;

    See:
        Goto Spawn;
    }
}
