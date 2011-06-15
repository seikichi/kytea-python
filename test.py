#!/usr/bin/python
# -*- coding: utf-8 -*-

# http://www.phontron.com/kytea/api.html

import kytea

kt = kytea.Kytea()
kt.readModel('/usr/local/share/kytea/model.bin')
util = kt.getStringUtil()

sentence = kytea.Sentence(util.mapString("もうなにもこわくない．"))
kt.calculateWS(sentence)
kt.calculateTags(sentence, 0)
words = sentence.words
for i in range(words.size()):
    print util.showString(words[i].surf),
    print '\t',
    for j in range(words[i].tags.size()):
        print util.showString(words[i].tags[j][0][0]),\
              "/",\
              words[i].tags[j][0][1],
    print
