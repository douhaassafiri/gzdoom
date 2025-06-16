// A custom AI class that replaces the base Demon
// This ambusher remains idle until the player comes within range, then activates and chases
class Ambusher : Demon replaces Demon
{
    // Flag to track if the ambusher is idle
    bool isIdle;

    // Called when the actor is first placed or spawns in the world
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        isIdle = true; // Start in idle mode
        bNoTarget = true; // Prevent AI from acquiring any targets automatically
    }

    // Called every game tick (frame)
    override void Tick()
    {
        super.Tick();

        if (isIdle)
        {
            // While idle, prevent movement
            vel.X = 0;
            vel.Y = 0;

            // Check for the local player
            PlayerPawn player = PlayerPawn(Players[ConsolePlayer].mo);
            if (player != null && player.health > 0)
            {
                // Measure distance between ambusher and player
                double dist = (player.Pos - Pos).Length();
                // Trigger activation if the player gets close
                if (dist < 128)
                {
                    WakeUp(player);
                }
            }
        }
    }

    // Wakes up the ambusher, transitioning it into active chase state
    void WakeUp(PlayerPawn target)
    {
        if (!isIdle) return;

        isIdle = false;
        bNoTarget = false; // Allow it to now acquire and attack a target
        self.target = target; // Assign the player as the current target

        SetStateLabel("See"); // Switch to the chasing animation state
    }

    States
    {
    // Idle spawn state (does nothing while idle)
    Spawn:
        SARG A 10;
        Loop;

    // Chase state triggered once the ambusher wakes up
    See:
        SARG AABBCCDD 4 A_Chase;
        Loop;

    // Melee attack state
    Melee:
        SARG E 8 A_FaceTarget;
        SARG F 8 A_SargAttack;
        Goto See;

    // Pain reaction state
    Pain:
        SARG G 4;
        SARG G 4 A_Pain;
        Goto See;

    // Death animation state
    Death:
        SARG H 8;
        SARG I 8 A_Scream;
        SARG J 8 A_NoBlocking;
        SARG K 8;
        Stop;
    }
}
