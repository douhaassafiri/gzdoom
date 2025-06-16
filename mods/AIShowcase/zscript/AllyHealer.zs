// A friendly support companion that follows the player and drops healing items.
// Interaction-based and passive, ideal for showcasing conditional logic and support AI.
class AllyHealer : MBFHelperDog replaces MBFHelperDog
{
    bool isFollowing; // Tracks if the healer is currently following the player
    PlayerPawn player; // The player being followed
    int healingCooldown; // Cooldown timer between stimpack drops

    // Allows interaction via the 'use' key. Makes the actor friendly.
    Default
    {
        +USESPECIAL
        +ISMONSTER
        +FRIENDLY
        +LOOKALLAROUND
        Health 100;
        Speed 25;
    }

    // Called once when the actor enters the world
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        isFollowing = false;
        healingCooldown = 0;
    }

    // Activated when the player presses 'use' on the dog
    override bool Used(Actor user)
    {
        if (!isFollowing && user is "PlayerPawn")
        {
            player = PlayerPawn(user);
            isFollowing = true;
            A_Log("Healer Dog: I'm following you now.");
            return true;
        }
        return false;
    }

    // Called every game tick. Handles following and healing.
    override void Tick()
    {
        super.Tick();

        if (isFollowing && player != null)
        {
            // Move toward the player
            Vector3 dir = player.Pos - Pos;
            double dist = dir.Length();

            if (dist > 32)
            {
                dir = dir.Unit();
                vel.X = dir.X * 1.5;
                vel.Y = dir.Y * 1.5;
            }
            else
            {
                vel.X = 0;
                vel.Y = 0;
            }

            // Drop a Stimpack every 3 seconds if player is not at full health
            if (healingCooldown > 0)
            {
                healingCooldown--;
            }
            else
            {
                if (player.health < player.GetMaxHealth())
                {
                    Spawn("Stimpack", Pos + (0, 0, 16), ALLOW_REPLACE);
                    A_Log("Healer Dog: Here's a stimpack!");
                    healingCooldown = 105; // 3 seconds
                }
            }
        }
    }

    // Prevents the healer from taking damage
    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod)
    {
        return 0;
    }

    States
    {
    Spawn:
        DOGS A 10;
        Loop;

    See:
        Goto Spawn;
    }
}
