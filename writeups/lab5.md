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

# 159 negation
Source: author
Vetted: f
Judgment: g
Phenomena: {neg}
gah gyùudanee ts’agts’aggee qing.anggan
gah gyùudan-ee ts’agts’ag-ee qing-.ang-gan
NEG horse-DEF wagon-DEF see-NEG-PST
`The horse absolutely did not see the wagon.'

# 160 negation
Source: author
Vetted: f
Judgment: u
Phenomena: {neg}
gah gyùudanee ts’agts’aggee qinggan
gah gyùudan-ee ts’agts’ag-ee qing-gan
NEG horse-DEF wagon-DEF see-PST
`The horse absolutely did not see the wagon.'

# 161 negation
Source: author
Vetted: f
Judgment: u
Phenomena: {neg}
gah gam gyùudanee ts’agts’aggee qinggan
gah gam gyùudan-ee ts’agts’ag-ee qing-gan
NEG NEG horse-DEF wagon-DEF see-PST
`The horse absolutely did not see the wagon.'
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

Haida has two negative adverbs: *gam* and *gah*. We could only add one in the customization system, so we added the later ourselves. They are syntactically interchangeable, but *gah* is more emphatic, rendering "absolutely did not". It is of the same type as *gam* and therefore acts the same, but we gave it a different predication to prevent one from generating from the other:

```
gah := neg-adv-lex &
  [ STEM < "gah" >,
    SYNSEM.LKEYS.KEYREL.PRED "neg_emphatic_rel" ].
```

This correctly allows #159 to parse and correctly prevents #160-61 from parsing.

Last week we reported a bug with negation that caused the following problem: the negative suffix is added to the verb, the `NEG` feature is saturated, so the verb does not select for the required negative adverb and incorrectly licensed sentences without it. Prof. Bender identified the following problems:

> 1. The feature `NEG-SAT` (which is used to track whether the obligatory adverb is picked up) was required to be `na-or-+` on clauses, and the `subj-head` rule inherits from the clause type.  
>
> 2. The feature `NEG-SAT` was not copied up by the lexical rules.

A constraint was removed from the clause which specified `NEGSAT +` and instead added to the root definition was to check for `NEG-SAT`, in order to prevent the sentences being licensed without the negative adverb. Prof. Bender changed `NEGSAT +` to `NEG-SAT na-or-+` in the root definition so that the grammar won't license sentences that do not have `NEG-SAT` satisfied, fixing the problem.

Clauses will have to be specified to check for `NEG-SAT +` in the future for clauses with embedded verbs.

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

Demonstratives in Masset Haida consist of inflectional phrasal demonstratives, related lexical demonstratives, and derivational demonstratives, based on six demonstrative roots:

| root            | semantics                                    |
|-----------------|----------------------------------------------|
| *7aa*           | near speaker and visible                     |
| *haw, huu, waa* | away from speaker and visible                |
| *7ahl*          | away from speaker and hearer and not visible |
| *gii*           | root question-word root                      |
| *tla, tlii*     | embedded question-word root                  |

Since we did not systematically collect demonstratives, our testsuite only covers a subset of these at this time, drawn from the first two rows, which conveniently sets up a basic proximal/distal semantic distinction.

#### Examples

```
# 18 np plural
Source: author
Vetted: f
Judgment: g
Phenomena: {det}
7aasgee gyùudan rad7wagan
7aasgee gyùudan rad-7wa-gan
these horse run-PL-PST
`These horses ran.'

# 19 np wrong det order
Source: author
Vetted: f
Judgment: u
Phenomena: {det}
gyùudan 7aasgee rad7wagan
gyùudan 7aasgee rad-7wa-gan
horse these run-PL-PST
`These horses ran.'

# 20 np impossible det
Source: author
Vetted: f
Judgment: u
Phenomena: {det}
7aasgee 7ittl’ dladahldagan
7aasgee 7ittl’ dladahlda-gan
these 1PL.ACC fall.down-PST
`These we fell down.'

# 22 aux
Source: a: 1193
Vetted: t
Judgment: g
Phenomena: {wo, tam}
7aasgee gyùudanee rad tlaagaang7wagan
7aasgee gyùudan-ee rad tlaagaang-7wa-gan
these horse-DEF run start-PL-PST
`These horses started to run.'

# 23 aux
Source: author
Vetted: f
Judgment: u
Phenomena: {wo}
7aasgee gyùudanee tlaagaang7wagan rad
7aasgee gyùudan-ee tlaagaang-7wa-gan rad
these horse-DEF start-PL-PST run
`These horses started to run.'

# 24 aux
Source: author
Vetted: f
Judgment: u
Phenomena: {tam}
7aasgee gyùudanee rad tlaagaang7wagan
7aasgee gyùudan-ee rad-7wa-gan tlaagaang
these horse-DEF run-PL-PST start
`These horses started to run.'

# 37 det with df suffix, plural
Source: author
Vetted: f
Judgment: g
Phenomena: {det}
7aasgee gyùudanee rad7wagan
7aasgee gyùudan-ee rad-7wa-gan
these horse-DEF run-PL-PST
`These horses ran.'

# 39 det with df suffix
Source: author
Vetted: f
Judgment: u
Phenomena: {det}
gyùudanee 7aasgee rad7wagan
gyùudan-ee 7aasgee rad-7wa-gan
horse-DEF these run-PL-PST
`These horses ran.'

# 40 det with df suffix, plural
Source: author
Vetted: f
Judgment: g
Phenomena: {det}
hlaa 7aasgee ts’agts’ag srids qing7wagan
hlaa 7aasgee ts’agts’ag srid-as qing-7wa-gan
1SG.NOM these wagons be.red-PRS see-PL-PST
`I saw these red wagons.'

# 71 possession - alienable -ra with dem and pn
Source: author
Vetted: f
Judgment: g
Phenomena: {poss, wo, det}
waaniis ’laangaa gyùudanee dladahldagan
waaniis ’laangaa gyùudan-ee dladahlda-gan
that her horse-DEF fall.down-PST
`That horse of hers fell down.' or `That one of her horses fell down.'

# 72 possession - alienable -ra with dem and pn
Source: author
Vetted: f
Judgment: u
Phenomena: {poss, wo, det}
waaniis gyùudanee ’laangaa dladahldagan
waaniis gyùudan-ee ’laangaa dladahlda-gan
that horse-DEF her fall.down-PST
`That horse of hers fell down.' or `That one of her horses fell down.'

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
```

#### Implementation

We chose to implement demonstratives as determiners as a) they appeared at the right edge and b) nothing appeared to contradict this. This latter point was later drawn into question by a single example too late to reconsider this choice. More is said about this in the "Problems" section below and again in the discussion of possessives.

Set up the necessary predicates:

```
demonstrative_a_rel := predsort.
proximal+dem_a_rel := demonstrative_a_rel. ; close to speaker
distal+dem_a_rel := demonstrative_a_rel.   ; away from speaker
```

Implement a determiner supertype:

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
```

and a `dem-det-lex` subtype as directed by the lab instructions:

> This type should have two subtypes (assuming you have demonstrative determiners as well as others in your language --- otherwise, just incorporate the constraints for demonstrative determiners into the type above).
>
>  1. The subtype for ordinary (non-demonstrative) determiners should add the constraint that the RELS list has exactly one thing on it, by adding the supertype single-rel-lex-item.
>
>  2. The subtype for demonstrative determiners should specify a RELS list with two things on it: the first should have the "exist_q_rel" for its PRED value. (It's already constrained to be a quant-relation because the type norm-hook-lex-item inherited by determiner-lex-supertype identifies the first element of the RELS list with the LKEYS.KEYREL.) The second one should be identified with LKEYS.ALTKEYREL and should be an arg1-ev-relation (the type we use for the relations of intransitive adjectives). The HOOK.INDEX.COG-ST inside the SPEC value should be constrained to activ+fam. Finally, the LBL and ARG1 of the arg1-ev-relation should be identified with the SPEC..HOOK.LTOP and SPEC..HOOK.INDEX of the determiner, respectively. (This will result in the demonstrative adjective relation sharing its handle with the N' the determiner attaches to.)

The result:

```
dem-det-lex := determiner-lex-supertype &
  [ SYNSEM [ LOCAL [ CAT.VAL.SPEC < [ LOCAL.CONT.HOOK [ INDEX #arg & [ COG-ST activ+fam ],
                                                        LTOP #lbl ] ] >,
                     CONT [ RELS < ! [ PRED "exist_q_rel" ],
                                     #altkeyrel ! > ] ],
            LKEYS.ALTKEYREL #altkeyrel & arg1-ev-relation & [ LBL #lbl,
                                                              ARG1 #arg ] ] ].
```

Finally, use this type in the lexicon, additionally setting the appropriate `PERNUM` values:

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

This implementation resulted in the correct MRS for nearly all of the examples, viz. the `_exist_q_rel`'s `ARG0.COG-ST` is set to the correct status and refers to the correct target. However, example #71 still fails to parse. Once understood, it became clear that the problem was that both demonstratives and possessives were implemented as determiners, viz. you cannot nest instances of `head-spec-phrase`.

As Prof. Bender reminded us

> You can only have one determiner (= specifier) per NP. If you’re getting both demonstratives and possessives in the same NP, then one of them can’t be a determiner.

However, implementing demonstratives as adjectives would lead to another problem, as it would call into question the determiner status of possessives (see below) since

> If the putative determiner appears between an adjective and the noun, it can’t be a determiner.

In other words, `ADJ-HEAD-INT` also will not accept a `head-spec-phrase`.

We did not have time to explore other options this week. We are considering implementing demonstratives as modifiers, but are not sure if this is theoretically valid and would like to explore our options further in coming labs.


### Possessives

#### Description

As stated in lab 3, possession in Haida follows an alienable/inalienable distinction, with alienable possession marked by either a) the *gyaa* linker word or b) the possessive suffix *-(ng)aa*, which is non-productive and highly lexically restricted to "pronouns and reflexively possessed kin terms". Meanwhile, inalienable possession is not marked on either the possessor or possessum and is lexically limited to kins terms, part terms, and certain additional nouns.

#### Examples

```
# 62 possession - alienable gyaa form non-1p
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
’la dalang gyaa ts’agts’aggee qinggan
’laa dalang gyaa ts’agts’ag-ee qing-gan
3p 2p POSS wagon-DEF see-PST
`She saw your wagon.'

# 63 possession - alienable gyaa form 1p
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
’la gyaagan ts’agts’aggee qinggan
’laa gyaagan ts’agts’ag-ee qing-gan
3p my wagon-DEF see-PST
`She saw my wagon.'

# 64 possession - alienable -ra form
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
’la ts’agts’aggee daangaa qinggan
’laa ts’agts’ag-ee daangaa qing-gan
3p wagon-DEF your see-PST
`She saw your wagon.'

# 65 possession - alienable NP
Source: author
Vetted: f
Judgment: g
Phenomena: {poss}
’la gyùudanee gyaa ts’agts’aggee qinggan
’laa gyùudan-ee gyaa ts’agts’ag-ee qing-gan
3p horse-DEF POSS wagon-DEF see-PST
`She saw the horse's wagon.'

# 66 possession - alienable NP
Source: author
Vetted: f
Judgment: u
Phenomena: {poss}
’la gyùudanee ts’agts’aggee qinggan
’laa gyùudan-ee ts’agts’ag-ee qing-gan
3p horse-DEF wagon-DEF see-PST
`She saw the horse's wagon.'

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

# 71 possession - alienable -ra with dem and pn
Source: author
Vetted: f
Judgment: g
Phenomena: {poss, wo, det}
waaniis ’laangaa gyùudanee dladahldagan
waaniis ’laangaa gyùudan-ee dladahlda-gan
that her horse-DEF fall.down-PST
`That horse of hers fell down.' or `That one of her horses fell down.'

# 72 possession - alienable -ra with dem and pn
Source: author
Vetted: f
Judgment: u
Phenomena: {poss, wo, det}
waaniis gyùudanee ’laangaa dladahldagan
waaniis gyùudan-ee ’laangaa dladahlda-gan
that horse-DEF her fall.down-PST
`That horse of hers fell down.' or `That one of her horses fell down.'
```

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

First, see the discussion of the problem raised by example #71 in the section on demonstratives above.

Second, our implementation currently does not handle the `X of Y's` form of possessives shown in #64 and #70. We believe that we could support this with some modification to or version of the `HEAD-SPEC` rule that allows for reversing the arguments. We did not have time to implement this this week but would like to do so in upcoming labs.


### Argument optionality

#### Description

In Haida, both subject and object pronouns can be dropped based on relative potency. The lower of two arguments can drop optionally if it's a complement and obligatorily if it's a subject.

#### Examples

```
# 60 argument optionality
Source: author
Vetted: f
Judgment: g
Phenomena: {agr, pro-d}
hlaa qing7wagan
hlaa qing-7wa-gan
1SG.NOM see-PL-PST
`I saw them.'

# 61 argument optionality
Source: author
Vetted: f
Judgment: g
Phenomena: {agr, pro-d}
dii qing7wagan
dii qing-7wa-gan
1SG.ACC see-PL-PST
`They saw me.'

# 157 argument optionality
Source: author
Vetted: f
Judgment: u
Phenomena: {pro-d}
qing7wagan
qing-7wa-gan
see-PL-PST
`I saw them.'

# 158 potency - hlaa must be POT high
Source: author
Vetted: f
Judgment: g
Phenomena: {pro-d}
’laa naan qing7wagan
’laa naan qing-7wa-gan
3p.POThigh grandmother see-PL-PST
`Grandmother saw them.' or `They saw grandmother.'
```

#### Implementation

In lab 3, we reported that the customization system did not allow us to add constraints to complement drop, only do this with subject drop. Furthermore, we had not captured the relative nature of potency in that implementation, instead opting for a simple high/low binary as a start.

To make subject drop work for low potency pronouns, we simply leave out any low potency subject from the lexicon. Therefore, #158 is always interpreted in the MRS as POT high.

Nevertheless, the subject drop rule had to be edited to select for both a low potency subject and a high potency complement. To do this, we created a list that contains a high potency element:

```
high-pot-list := list.

high-pot-cons := high-pot-list & cons &
  [ FIRST.LOCAL.CONT.HOOK.INDEX.PNG.POTENCY high,
    REST list ].

high-pot-null := high-pot-list & null.
```

The customization system had created a `context1-decl-head-opt-subj-phrase`, which specified that the subj of the head daughter be `POT low` and `PERNUM 3rd`. We then called the `high-pot-list` under complements on the head daughter and specified that the head daughter be `LIGHT +` so that this rule would occur lower in the tree:

```
context1-decl-head-opt-subj-phrase := decl-head-opt-subj-phrase &
  [ HEAD-DTR.SYNSEM [LIGHT +,
    LOCAL.CAT.VAL [SUBJ.FIRST.LOCAL.CONT.HOOK.INDEX.PNG [ POTENCY low,
                                                          PERNUM 3rd ],
   COMPS high-pot-list ] ]].
```

Because this rule inherits from `basic-head-opt-subj-phrase`, it was necessary to remove the `COMPS < >` from `basic-head-opt-subj-phrase`. This correctly licenses #61, with the correct semantics (the subject is `PERNUM 3rd`, `POT low` and the complement is `POT high`).

To implement optionality of low potency objects, we had to add a phrase structure rule to `rules.tdl` and then define it:

```
context1-head-opt-comp-phrase := basic-head-opt-comp-phrase &
  [ SYNSEM.LIGHT -,
    HEAD-DTR.SYNSEM.LOCAL.CAT.VAL [SUBJ < [ LOCAL.CONT.HOOK.INDEX.PNG.POTENCY high ] >,
  COMPS < [ LOCAL.CONT.HOOK.INDEX.PNG [POTENCY low,
                                       PERNUM 3rd ] ] > ] ].
```

This rule is `LIGHT -`, and specifies a high potency on the subject and low potency and `PERNUM 3rd` on the complement to be dropped. This correctly licenses #60, with the correct semantics (the complement is `PERNUM 3rd`, `POT low` and the subject is `POT high`). These rules correctly rule out the possibility of both arguments dropping, shown in #157, which is illegal in Haida. Because the `head-opt-comps` rule has a head mother that is `LIGHT -`, it cannot serve as input to the `head-opt-subj` rule, which requires a `LIGHT +` daughter.

#### Problems

None. All relevant test sentences are analyzed as expected.

### Additional fixes and problems

## Coverage

## Baseline Comparison

## Corpus
