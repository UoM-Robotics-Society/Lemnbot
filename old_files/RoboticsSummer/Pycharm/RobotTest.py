#! /usr/bin/python

from poppy.creatures import PoppyHumanoid

bot = PoppyHumanoid()

print(len(bot.motors))

for m in bot.motors:
    print(m.name)