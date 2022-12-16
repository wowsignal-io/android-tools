#!/system/bin/env bash

function dog {
    echo -ne "\033[33m"
}

function nose {
    echo -ne "\033[37m"
}

function clr {
    echo -ne "\033[0m"
}

function bubble {
    echo " ____________________________________________________ "
    echo "/                                                    \\"

    while IFS= read -r line; do
        echo -n "| ${line}"
        local l="${#line}"
        local p=$((51-l))
        for (( c=0; c<p; c++ )); do
            echo -n " "
        done
        echo "|"
    done <<< "$1"

    echo "\\____________________________    ____________________/"
    echo "                             |  /"
    echo "                             | /"
    echo "                             |/"
}

xs=$((RANDOM % 7))

case "${xs}" in
    0)
    bubble "Tomorrow, and tomorrow, and tomorrow,
Creeps in this petty pace from day to day,
To the last syllable of recorded time;
And all our yesterdays have lighted fools
The way to dusty death. Out, out, brief candle!
Life's but a walking shadow, a poor player
That struts and frets his hour upon the stage,
And then is heard no more. It is a tale
Told by an idiot, full of sound and fury,
Signifying nothing."
    ;;
    1)
    bubble "Full fathom five thy father lies;
Of his bones are coral made;
Those are pearls that were his eyes;
Nothing of him that doth fade,
But doth suffer a sea-change
Into something rich and strange."
    ;;
    2)
    bubble "Now is the winter of our discontent
Made glorious summer by this sun of York;
And all the clouds, that lour'd upon our house,
In the deep bosom of the ocean buried."
    ;;
    3)
    bubble "O Romeo, Romeo! wherefore art thou Romeo?
Deny thy father and refuse thy name;
Or, if thou wilt not, be but sworn my love,
And I'll no longer be a Capulet."
    ;;
    4)
    bubble "To be, or not to be, — that is the question: —
Whether 'tis nobler in the mind to suffer
The slings and arrows of outrageous fortune,
Or to take arms against a sea of troubles,
And by opposing end them? — To die, to sleep, —
No more; and by a sleep to say we end
The heart-ache, and the thousand natural shocks
That flesh is heir to, — 'tis a consummation
Devoutly to be wish'd."
    ;;
    5)
    bubble "This is the excellent foppery of the world, that,
when we are sick in fortune,
often the surfeit of our own behaviour,
we make guilty of our disasters the sun,
the moon, and the stars;
as if we were villains by necessity,
fools by heavenly compulsion,
knaves, thieves, and treachers
by spherical predominance,
drunkards, liars, and adulterers
by an enforced obedience of planetary influence;
and all that we are evil in,
by a divine thrusting on:
an admirable evasion of whore-master man,
to lay his goatish disposition
to the charge of a star!"
    ;;
    6)
    bubble "Men at some time are masters of their fates:
The fault, dear Brutus, is not in our stars,
But in ourselves, that we are underlings."
    ;;
esac

echo "`dog`                        __      "
echo "`dog` (\\,-------------------/()'--`nose`o  "
echo "`dog`  (_    ______________    /~\"   "
echo "`dog`   (_)_)             (_)_)      "
echo
clr