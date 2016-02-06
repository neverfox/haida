# Lab 5

### University of Washington, LING 567, Winter 2016

#### Author: Roman Pearah
#### Partner: Kristen Piepgrass

#### Language: Haida (Masset dialect)

---

## Phenomena

### Adverbial Modifiers

#### Description

We were instructed to assume only intersective modification in this lab and ignore scopal modification except in the case of the negative adverb. As it turns out, this is very close to the reality of Haida:

> the only adverbs which show any scope behavior are the negative *gam* ‘not’ and *tlaan* ‘no more’.
>
> -- <cite>Enrico p.53</cite>

Adverbs only occur pre-head, attaching to V, VP or S (tending towards sentence-initial, as in #88 below, and non-verb-adjacent, as in #88-89 and #92-93 below).

#### Examples

```
# 88 adverbs example constructed from data on pages 40
Source: author
Vetted: f
Judgment: g
Phenomena: {adv}
neesdagaang.an gyùudanee ts’agts’aggee tlagaaydagan
neesdagaang.an gyùudan-ee ts’agts’ag-ee tlagaayda-gan
right.away horse-DEF wagon-DEF injure-PST
`The horse damaged the wagon right away.'

# 89 adverbs example constructed from data on pages 40
Source: author
Vetted: f
Judgment: g
Phenomena: {adv}
gyùudanee neesdagaang.an ts’agts’aggee tlagaaydagan
gyùudan-ee neesdagaang.an ts’agts’ag-ee tlagaayda-gan
horse-DEF right.away wagon-DEF injure-PST
`The horse damaged the wagon right away.'

# 90 adverbs example constructed from data on pages 40
Source: author
Vetted: f
Judgment: g
Phenomena: {adv}
gyùudanee ts’agts’aggee neesdagaang.an tlagaaydagan
gyùudan-ee ts’agts’ag-ee neesdagaang.an tlagaayda-gan
horse-DEF wagon-DEF right.away injure-PST
`The horse damaged the wagon right away.'

# 91 adverbs example constructed from data on pages 40
Source: author
Vetted: f
Judgment: u
Phenomena: {adv}
gyùudanee ts’agts’aggee tlagaaydagan neesdagaang.an
gyùudan-ee ts’agts’ag-ee tlagaayda-gan neesdagaang.an
horse-DEF wagon-DEF injure-PST right.away
`The horse damaged the wagon right away.'

# 92 negation and adverbs example constructed from data on pages 40
Source: author
Vetted: f
Judgment: g
Phenomena: {adv, neg}
neesdagaang.an gam gyùudanee ts’agts’aggee tlagaayda.anggan
neesdagaang.an gam gyùudan-ee ts’agts’ag-ee tlagaayda-.ang-gan
right.away NEG horse-DEF wagon-DEF injure-NEG-PST
`The horse did not damage the wagon right away.'

# 93 negation and adverbs example constructed from data on pages 40
Source: author
Vetted: f
Judgment: g
Phenomena: {adv, neg}
gam neesdagaang.an gyùudanee ts’agts’aggee tlagaayda.anggan
gam neesdagaang.an gyùudan-ee ts’agts’ag-ee tlagaayda-.ang-gan
NEG right.away horse-DEF wagon-DEF injure-NEG-PST
`The horse did not damage the wagon right away.'
```

#### Implementation

The customization system only allowed for post-head modifiers (and then only for noun targets). In order to incorporate Haida adverbs, we added the following to `rules.tdl` (`adj` referring, of course, to "adjunct" not "abjective"):

```
adj-head-int := adj-head-int-phrase.
```

This alone is sufficient to allow sentences like #88-90 to parse correctly. However, to prevent the ungrammatical #91 (showing a post-head adverb) from parsing, we had to add the following to `haida.tdl`:

```
adverb-lex := basic-adverb-lex & intersective-mod-lex &
  [ SYNSEM [ LOCAL [ CAT [ HEAD.MOD < [ LOCAL.CAT.HEAD verb ]>,
                           POSTHEAD -,
                           VAL [ SPR < >,
                                 SUBJ < >,
                                 COMPS < >,
                                 SPEC < > ] ] ] ] ].
```

Specifically, the `POSTHEAD -` prevents an adverb from attaching to the right of the constituent that it modifies.

#### Problems

None. All relevant test sentences are analyzed as expected.

### Adjectival modifiers

#### Description

As noted in past labs, attributive adjectives attach to the *right* of the constituent that they modify, and they only modify noun phrases.

#### Examples

```
#122 attributive adjectives
Source: a:589
Vetted: s
Judgement: g
Phenomena: {adj, cop}
na t’iij q’iigaa ’laagang
na t’iij q’iigaa ’laa-gang
house some.of be.old be.good-PRS
`Some old houses are good.'

#123 attributive adjectives
Source: a:589
Vetted: s
Judgement: g
Phenomena: {adj, cop}
na q’iigaa t’iij ’laagang
na q’iigaa t’iij ’laa-gang
house be.old some.of be.good-PRS
`Some old houses are good.'

#124 attributive adjectives
Source: author
Vetted: f
Judgement: u
Phenomena: {adj, cop}
na t’iij q’iigaagang ’laagang
na t’iij q’iigaa-gang ’laa-gang
house some.of be.old-PRS be.good-PRS
`Some old houses are good.'

#125 attributive adjectives
Source: author
Vetted: f
Judgement: u
Phenomena: {adj, cop}
na q’iigaagang t’iij ’laagang
na q’iigaa-gang t’iij ’laa-gang
house be.old-PRS some.of be.good-PRS
`Some old houses are good.'

#126 attributive adjectives
Source: author
Vetted: f
Judgement: g
Phenomena: {adj}
gyùudanee 7iw7aan dladahldagan
gyùudan-ee 7iw7aan dladahlda-gan
horse-DEF be.big fall.down-PST
`The big horse fell down.'

#127 attributive adjectives
Source: author
Vetted: f
Judgement: g
Phenomena: {adj, cop}
xa.a q’iigaa 7aanàa 7iijang
xa.a q’iigaa 7aanàa 7iij-gang
mallard be.old in.next.room be-PRS
`An old mallard is in the next room.'

#128 attributive adjectives
Source: author
Vetted: f
Judgement: u
Phenomena: {adj}
7iw7aan gyùudanee dladahldagan
7iw7aan gyùudan-ee dladahlda-gan
be.big horse-DEF fall.down-PST
`The big horse fell down.'

#129 attributive adjectives
Source: author
Vetted: f
Judgement: u
Phenomena: {adj, cop}
q’iigaa xa.a 7aanàa 7iijang
q’iigaa xa.a 7aanàa 7iij-gang
be.old mallard in.next.room be-PRS
`An old mallard is in the next room.'

#130 attributive adjectives
Source: author
Vetted: f
Judgement: u
Phenomena: {adj, cop}
q’iigaa xa.a 7aanàa 7iijang
q’iigaa xa.a 7aanàa 7iij-gang
be.old mallard in.next.room be-PRS
`An old mallard is in the next room.'

# 131 attributive adjectives (variation of #40)
Source: author
Vetted: f
Judgment: u
Phenomena: {adj}
hlaa 7aasgee srids ts’agts’ag qing7wagan
hlaa 7aasgee srid-as ts’agts’ag qing-7wa-gan
1SG.NOM these be.red-PRS wagons see-PL-PST
`I saw these red wagons.'

# 132 attributive adjectives (variation of #40)
Source: author
Vetted: f
Judgment: u
Phenomena: {adj}
hlaa 7aasgee ts’agts’ag sridan qing7wagan
hlaa 7aasgee ts’agts’ag srid-gan qing-7wa-gan
1SG.NOM these wagons be.red-PST see-PL-PST
`I saw these red wagons.'

# 133 attributive adjectives
Source: a:588
Vetted: s
Judgment: g
Phenomena: {adj}
sguusadee t’iij ts’uudalaas ’la daanggan
sguusiid-ee t’iij ts’uudalaa-as ’laa daang-gan
potato-DEF some.of be.small-PRS 3p throw.away-PST
`She threw away some of the small pototoes.'

# 134 attributive adjectives
Source: a:588
Vetted: s
Judgment: g
Phenomena: {adj}
sguusadee ts’uudalaas t’iij ’la daanggan
sguusiid-ee ts’uudalaa-as t’iij ’laa daang-gan
potato-DEF be.small-PRS some.of 3p throw.away-PST
`She threw away some of the small pototoes.'

# 135 attributive adjectives (variation from a:588, wrong tense)
Source: author
Vetted: f
Judgment: u
Phenomena: {adj}
sguusadee t’iij ts’uudalaagan ’la daanggan
sguusiid-ee t’iij ts’uudalaa-gan ’laa daang-gan
potato-DEF some.of be.small-PST 3p throw.away-PST
`She threw away some of the small pototoes.'

# 136 attributive adjectives (variation from a:588, wrong tense)
Source: author
Vetted: f
Judgment: u
Phenomena: {adj}
sguusadee ts’uudalaagan t’iij ’la daanggan
sguusiid-ee ts’uudalaa-gan t’iij ’laa daang-gan
potato-DEF be.small-PST some.of 3p throw.away-PST
`She threw away some of the small pototoes.'
```

#### Implementation

We had previously added attributive adjectives to our lexicon as "a single class that is strictly attributive, occurs after the noun and impossibly behaves predicately." No changes were required for attributive adjectives as `attrib-adj-adj-lex` was already `POSTHEAD +`:

```
attrib-adj-adj-lex := attr-only-adj-lex &
  [ SYNSEM.LOCAL.CAT.POSTHEAD + ].
```

#### Problems

We are still unable to parse adjectives with tense inflection (#133-134 above). We plan to analyze these as relative clauses (see [here](https://catalyst.uw.edu/gopost/conversation/ebender/949464 FMI)), and will implement this later in the quarter.

### Agreement between adjectives and head nouns

Haida does not have this phenomenon.

### Definiteness

#### Description

As previously noted, definiteness in Haida can be represented as an inflectional suffix *-(g)ee*, limited to alienable nouns, and our best interpretation of its cognitive status is that it represents **uniq+fam+act** in the Borthen and Haugereid hierarchy, given that the examples in Enrico appear to correlate with the English definite article *the* in translation. Bare nouns without the suffix correlate to the English indefinite article *a* or cognitive status **type-id**. Demonstratives and possessives can also lend definiteness to a noun but this will be discussed in the sections for those phenomena; this section deals only with the inflectional definite suffix.

#### Examples

We do not have any examples that deal exclusively with the definite suffix, as it is ubiquitous in our testsuite. For example:

```
# 1 it wo
Source: author
Vetted: f
Judgment: g
Phenomena: {wo, det}
gyùudanee dladahldagan
gyùudan-ee dladahlda-gan
horse-DEF fall.down-PST
`The horse fell down.'

# 2 it wo
Source: author
Vetted: f
Judgment: u
Phenomena: {wo}
dladahldagan gyùudanee
dladahlda-gan gyùudan-ee
fall.down-PST horse-DEF
`The horse fell down.'

# 3 tr wo
Source: a:75
Vetted: s
Judgment: g
Phenomena: {wo}
ts’agts’aggee gyùudanee tlagaaydagan
ts’agts’ag-ee gyùudan-ee tlagaayda-gan
wagon-DEF horse-DEF injure-PST
`The wagon injured the horse.' or `The horse damaged the wagon.'

# 4 tr wo
Source: a:75
Vetted: s
Judgment: g
Phenomena: {wo}
gyùudanee ts’agts’aggee tlagaaydagan
gyùudan-ee ts’agts’ag-ee tlagaayda-gan
horse-DEF wagon-DEF injure-PST
`The horse damaged the wagon.'

# 5 tr wo
Source: author
Vetted: f
Judgment: u
Phenomena: {wo}
gyùudanee tlagaaydagan ts’agts’aggee
gyùudan-ee tlagaayda-gan ts’agts’ag-ee
horse-DEF injure-PST wagon-DEF
`The horse damaged the wagon.'
```

However, the fact that is is restricted to alienable nouns makes the following examples relevant (referring to `naan` ‘grandmother’, an inalienable noun that cannot take the definite suffix):

```
# 67 possession - inalienable
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
dii naan gyùudanee gyaa ts’agts’aggee qinggan
dii naan gyùudan-ee gyaa ts’agts’ag-ee qing-gan
my grandmother horse-DEF POSS wagon-DEF see-PST
`My grandmother saw the horse's wagon.'

# 68 possession - inalienable
Source: author
Vetted: f
Judgment: u
Phenomena: {poss}
gyaagan naan gyùudanee gyaa ts’agts’aggee qinggan
gyaagan naan gyùudan-ee gyaa ts’agts’ag-ee qing-gan
my grandmother horse-DEF POSS wagon-DEF see-PST
`My grandmother saw the horse's wagon.'

# 69 possession - mixed alienable/inalienable
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
dii naan gyaa gyùudanee dladahldagan
dii naan gyaa gyùudan-ee dladahlda-gan
my grandmother POSS horse-DEF fall.down-PST
`My grandmother's horse fell down.'

# 70 possession - mixed alienable/inalienable
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
dii naan gyaa ts’agts’aggee diinaa dladahldagan
dii naan gyaa ts’agts’ag-ee diinaa dladahlda-gan
my grandmother POSS wagon-DEF my fall.down-PST
`My grandmother's wagon of mine fell down.'

#155 possession - pronoun with inalienable
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
dii naan dladahldagan
dii naan dladahlda-gan
my grandmother fall.down-PST
`My grandmother fell down.'

#156 possession - pronoun with inalienable
Source: author
Vetted: f
Judgment: u
Phenomena: {poss, def}
dii naanee dladahldagan
dii naan-ee dladahlda-gan
my grandmother-DEF fall.down-PST
`My grandmother fell down.'
```

The last of these examples was added specifically to provide an ungrammatical example for this case.

#### Implementation

Prior to this lab, our common nouns existed in the lexicon as one type (`common-noun-lex`) and we had entries where the definite suffix was part of the stem. Faced with implementing definiteness explicitly, we

* added a new boolean feature `alienability`
* added two subtypes of `common-noun-lex`: `alienable-noun-lex` and `inalienable-noun-lex`, having a `+` or `-` value for the `alienability` feature respectively
* moved our noun entries to the approprite subtype and removed all definite suffixes from the stems
* added a new obligatory noun position class with `alienable-noun-lex` as the input
* added two new lexical rules for this position class
  * a constant lexical rule for `type-id` cognitive status
  * an inflecting rule for the definite suffix *-ee* and `uniq+fam+act`
* "assumed a morpho-phonological analyzer" by using *-ee* for all instances of the suffix in the translit-seg lines of the testsuite

Most of these changes were accomplished through additional matrix customization. However, setting the `COG-ST` value appropriately was entered by hand. Originally, we had set firm values:

```
indef-lex-rule := cog-st-lex-rule-super & const-lex-rule &
  [ SYNSEM.LOCAL.CONT.HOOK.INDEX.COG-ST type-id ].

def-lex-rule := cog-st-lex-rule-super & infl-lex-rule &
  [ SYNSEM.LOCAL.CONT.HOOK.INDEX.COG-ST uniq+fam+act ].
```

The result of these changes is that alienable nouns can optionally take the definite suffix, and inalienable nouns cannot take it at all. Furthermore, the suffix drives the appropriate `COG-ST` value. Inalienable nouns are always associated with a possessor, so it wasn't necessary to ensure here that they had a definite cognitive status by default.

However, our testsuite indicated to us that while bare NPs have definiteness fixed by the suffix, they are optional in the presense of possessive and demonstrative determiners. This required us to go back and attach cognitive status values as `OPT-CS` and copy them to the `HEAD-DTR` in the case of bare NPs:

```
bare-np-phrase := basic-bare-np-phrase &
  [ C-CONT.RELS <! [ PRED "exist_q_rel" ] !>,
    HEAD-DTR.SYNSEM [ OPT-CS #optcs,
                      LOCAL.CONT.HOOK.INDEX.COG-ST #optcs ] ].

indef-lex-rule := cog-st-lex-rule-super & const-lex-rule &
  [ SYNSEM.OPT-CS type-id ].

def-lex-rule := cog-st-lex-rule-super & infl-lex-rule &
  [ SYNSEM.OPT-CS uniq+fam+act ].
```

#### Problems

None. All relevant test sentences are analyzed as expected.

### Demonstratives

#### Description

#### Examples

#### Implementation

```
demonstrative_a_rel := predsort.
proximal+dem_a_rel := demonstrative_a_rel. ; close to speaker
distal+dem_a_rel := demonstrative_a_rel.   ; away from speaker
```

```
determiner-lex-supertype := norm-hook-lex-item & norm-zero-arg & non-mod-lex-item &
  [ SYNSEM [ LOCAL [ CAT [ HEAD det,
                           VAL [ SPEC.FIRST.LOCAL.CONT.HOOK [ INDEX #ind,
                                                              LTOP #larg ],
                                 SPR < >,
                                 SUBJ < >,
                                 COMPS < > ] ],
                     CONT.HCONS.LIST.FIRST qeq & [ HARG #harg,
                                                   LARG #larg ] ],
             LKEYS.KEYREL quant-relation & [ ARG0 #ind,
                                             RSTR #harg ] ] ].

dem-det-lex := determiner-lex-supertype &
  [ SYNSEM [ LOCAL [ CAT.VAL.SPEC < [ LOCAL.CONT.HOOK [ INDEX #arg & [ COG-ST activ+fam ],
                                                        LTOP #lbl ] ] >,
                     CONT [ RELS < ! [ PRED "exist_q_rel" ],
                                     #altkeyrel ! > ] ],
            LKEYS.ALTKEYREL #altkeyrel & arg1-ev-relation & [ LBL #lbl,
                                                              ARG1 #arg ] ] ].
```

```
7aajii := dem-det-lex &
  [ STEM < "7aajii" >,
    SYNSEM.LKEYS.ALTKEYREL.PRED "proximal+dem_a_rel",
    SYNSEM.LKEYS.ALTKEYREL.ARG1.PNG.PERNUM 3sg ].

waaniis := dem-det-lex &
  [ STEM < "waaniis" >,
    SYNSEM.LKEYS.ALTKEYREL.PRED "distal+dem_a_rel",
    SYNSEM.LKEYS.ALTKEYREL.ARG1.PNG.PERNUM 3pl ].

7aasgee := dem-det-lex &
  [ STEM < "7aasgee" >,
    SYNSEM.LKEYS.ALTKEYREL.PRED "proximal+dem_a_rel",
    SYNSEM.LKEYS.ALTKEYREL.ARG1.PNG.PERNUM 3sg ].

waasgee := dem-det-lex &
  [ STEM < "waasgee" >,
    SYNSEM.LKEYS.ALTKEYREL.PRED "distal+dem_a_rel",
    SYNSEM.LKEYS.ALTKEYREL.ARG1.PNG.PERNUM 3pl ].
```

#### Problems

### Possessives

#### Description

As stated in lab 3, possession in Haida follows an alienable/inalienable distinction, with alienable possession marked by either a) the *gyaa* linker word or b) the possessive suffix *-(ng)aa*, which is non-productive and highly lexically restricted to "pronouns and reflexively possessed kin terms". Meanwhile, inalienable possession is not marked on either the possessor or possessum and is lexically limited to kins terms, part terms, and certain additional nouns.

#### Examples

#### Implementation

As the description implies, it should be possible to model possession in Haida by implementing both a linker word for alienable nouns and possessive pronouns determiners for both kinds (following the suggestion in the lab instructions). Since we had already established the necessary alienable/inalienable distinction between nouns for definiteness, we were able to take advantage of it to create two subtypes of `poss-pron-det-lex` to constrain the `ALIENABILITY` feature appropriately.

Pronouns:

```
poss-pron-det-lex := determiner-lex-supertype &
  [ SYNSEM [ LOCAL [ CAT.VAL.SPEC < [ LOCAL.CONT.HOOK [ INDEX #arg1 & [ COG-ST uniq+fam+act ],
                                                        LTOP #lbl ] ] >,
                     CONT [ RELS < ! [ PRED "exist_q_rel" ],
                                     arg12-ev-relation & [ PRED "poss_rel",
                                                           LBL #lbl,
                                                           ARG1 #arg1,
                                                           ARG2 #arg2 ],
                                     quant-relation & [ PRED "exist_q_rel",
                                                        ARG0 #arg2,
                                                        RSTR #harg ],
                                     #altkeyrel ! >,
                            HCONS < ! [ ], qeq & [ HARG #harg,
                                                   LARG #lbl2 ] ! > ] ],
            LKEYS.ALTKEYREL #altkeyrel & noun-relation & [ PRED "pron_rel",
                                                           LBL #lbl2,
                                                           ARG0 #arg2 & [ COG-ST activ-or-more,
                                                                          SPECI + ] ] ] ].

alienable-poss-pron-det-lex := poss-pron-det-lex &
  [ SYNSEM.LOCAL.CAT.VAL.SPEC.FIRST.LOCAL.CONT.HOOK.INDEX.PNG.ALIENABILITY +].

inalienable-poss-pron-det-lex := poss-pron-det-lex &
  [ SYNSEM.LOCAL.CAT.VAL.SPEC.FIRST.LOCAL.CONT.HOOK.INDEX.PNG.ALIENABILITY -].
```

Using the appropriate type, we could then associate each possessive pronoun in our lexicon with the appropriate `PERNUM` value:

```
gyaagan := alienable-poss-pron-det-lex &
  [ STEM < "gyaagan" >,
    SYNSEM.LKEYS.ALTKEYREL.ARG0.PNG.PERNUM 1sg ].

diinaa := alienable-poss-pron-det-lex &
  [ STEM < "diinaa" >,
    SYNSEM.LKEYS.ALTKEYREL.ARG0.PNG.PERNUM 1sg ].

daangaa := alienable-poss-pron-det-lex &
  [ STEM < "daangaa" >,
    SYNSEM.LKEYS.ALTKEYREL.ARG0.PNG.PERNUM 2sg ].

’laangaa := alienable-poss-pron-det-lex &
  [ STEM < "’laangaa" >,
    SYNSEM.LKEYS.ALTKEYREL.ARG0.PNG.PERNUM 3sg ].

dii_2 := inalienable-poss-pron-det-lex &
  [ STEM < "dii" >,
    SYNSEM.LKEYS.ALTKEYREL.ARG0.PNG.PERNUM 1sg ].
```

Linker Word:

```
adposition-lex := basic-adposition-lex & intersective-mod-lex & norm-ltop-lex-item &
  [ SYNSEM [ LKEYS.KEYREL [ ARG0 #arg0,
                            ARG1 #xarg,
                            ARG2 #ind ],
             LOCAL [ CONT.HOOK [ XARG #xarg,
                                 INDEX #arg0 ],
                     CAT [ POSTHEAD -,
               HEAD.MOD < [ LOCAL [ CAT [ HEAD noun,
                                                      VAL.SPR cons ],
                                                CONT.HOOK.INDEX #xarg ]] >,
                      VAL [ SPR < >,
                            COMPS < [ LOCAL [ CAT [ HEAD noun,
                                                    VAL.SPR < > ],
                                              CONT.HOOK.INDEX #ind ]] >,
                            SUBJ < > ]]]]].
```

```
gyaa := adposition-lex &
  [ STEM < "gyaa" >,
    SYNSEM.LKEYS.KEYREL [ PRED "poss_rel",
                          ARG1.COG-ST uniq+fam+act ] ].
```

The only edit form the `adposition-lex` provided to us as an example was the addition of `POSTHEAD -` to constrain the linker word to appear before whatever it modifies.

#### Problems

TODO: mention #71

### Argument optionality

#### Description

#### Examples

#### Implementation

#### Problems

### Additional fixes

## Coverage

## Baseline Comparison

## Corpus
