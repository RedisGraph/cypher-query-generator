/**
 * Copyright (c) 2015-2020 "Neo Technology,"
 * Network Engine for Objects in Lund AB [http://neotechnology.com]
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * Attribution Notice under the terms of the Apache License 2.0
 * 
 * This work was created by the collective efforts of the openCypher community.
 * Without limiting the terms of Section 6, any Derivative Work that is not
 * approved by the public consensus process of the openCypher Implementers Group
 * should not be described as “Cypher” (and Cypher® is a registered trademark of
 * Neo4j Inc.) or as "openCypher". Extensions by implementers or prototypes or
 * proposals for change that have been documented or implemented should only be
 * described as "implementation extensions to Cypher" or as "proposed changes to
 * Cypher that are not yet approved by the openCypher community".
 */
grammar Cypher;

oC_Cypher
      :  SP oC_Statement ( SP ';' )? SP EOF ;

oC_Statement
         :  oC_Query ;

oC_Query
     :  oC_RegularQuery
         ;

oC_RegularQuery
           :  oC_SinglePartQuery
               | oC_MultiPartQuery
               ;

oC_SinglePartQuery
               :  ( ( oC_ReadingClause SP )* oC_Return )
                   | ( ( oC_ReadingClause SP )+ oC_UpdatingClause ( SP oC_UpdatingClause )* ( SP oC_Return )? )
                   | ( oC_UpdatingStartClause ( SP oC_UpdatingClause )* ( SP oC_Return )? )
                   ;

oC_MultiPartQuery
			  :  ( ( ( ( oC_ReadingClause SP )+ ( SP oC_UpdatingClause )* ) | ( oC_UpdatingStartClause ( SP oC_UpdatingClause )* ) ) ( oC_With SP) )+ oC_SinglePartQuery ;

oC_UpdatingStartClause
              : oC_Create
			      | oC_Merge
				  ;

oC_UpdatingClause
              :  oC_Create
                  | oC_Merge
                  | oC_Delete
                  | oC_Set
                  ;

oC_ReadingClause
             :  oC_Match
                 | oC_Unwind
                 /* | oC_InQueryCall */
                 ;

oC_Match
     :  (MATCH SP oC_Pattern ( SP oC_Where )? ;

OPTIONAL : ('O') ('P') ('T') ('I') ('O') ('N') ('A') ('L')  ;

MATCH : ('M') ('A') ('T') ('C') ('H')  ;

oC_Unwind
      :  UNWIND SP '[' ZeroDigit (',' SP NonZeroDigit)* ']' SP AS SP oC_Variable ;

UNWIND : ('U') ('N') ('W') ('I') ('N') ('D')  ;

AS : ('A') ('S')  ;

oC_Merge
     :  MERGE SP oC_PatternPart ( SP oC_MergeAction )* ;

MERGE : ('M') ('E') ('R') ('G') ('E')  ;

oC_MergeAction
           :  ( ON SP MATCH SP oC_Set )
               | ( ON SP CREATE SP oC_Set )
               ;

ON : ('O') ('N')  ;

CREATE : ('C') ('R') ('E') ('A') ('T') ('E')  ;

oC_Create
      :  CREATE SP oC_Pattern ;

oC_Set
   :  SET SP oC_SetItem ( ',' SP oC_SetItem )* ;

SET : ('S') ('E') ('T')  ;

oC_SetItem
       :  ( oC_PropertyExpression SP '=' SP rG_Expression )
           /* | ( oC_Variable SP '=' SP rG_Expression ) */
           /* | ( oC_Variable SP '+=' SP rG_Expression ) */
           ;

oC_Delete
      :  DETACH SP DELETE SP oC_Variable ( SP ',' SP oC_Variable )* ;

DETACH : ('D') ('E') ('T') ('A') ('C') ('H')  ;

DELETE : ('D') ('E') ('L') ('E') ('T') ('E')  ;

oC_InQueryCall
           :  CALL SP oC_ExplicitProcedureInvocation ( SP YIELD SP oC_YieldItems )? ;

CALL : ('C') ('A') ('L') ('L')  ;

YIELD : ('Y') ('I') ('E') ('L') ('D')  ;

oC_StandaloneCall
              :  CALL SP ( oC_ExplicitProcedureInvocation | oC_ImplicitProcedureInvocation ) ( SP YIELD SP oC_YieldItems )? ;

oC_YieldItems
          :  ( oC_YieldItem ( SP ',' SP oC_YieldItem )* ) ( SP oC_Where )? ;

oC_YieldItem
         :  ( oC_ProcedureResultField SP AS SP )? oC_Variable ;

oC_With
    :  SP WITH oC_ProjectionBody ( SP oC_Where )? ;

WITH : ('W') ('I') ('T') ('H')  ;

oC_Return
      :  RETURN oC_ProjectionBody ;

RETURN : ('R') ('E') ('T') ('U') ('R') ('N')  ;

oC_ProjectionBody
              :  ( SP DISTINCT )? SP oC_ProjectionItems ( SP oC_Order )? ( SP oC_Skip )? ( SP oC_Limit )? ;

DISTINCT : ('D') ('I') ('S') ('T') ('I') ('N') ('C') ('T')  ;

oC_ProjectionItems
               :  ( '*' ( SP ',' SP oC_ProjectionItem )* )
                   | ( oC_ProjectionItem ( ',' SP oC_ProjectionItem )* )
                   ;

oC_ProjectionItem
              :  ( rG_Expression SP AS SP oC_Variable )
                  | rG_Expression
                  ;

oC_Order
     :  ORDER SP BY SP oC_SortItem ( ',' SP oC_SortItem )* ;

ORDER : ('O') ('R') ('D') ('E') ('R')  ;

BY : ('B') ('Y')  ;

oC_Skip
    :  L_SKIP SP DecimalInteger;

L_SKIP : ('S') ('K') ('I') ('P')  ;

oC_Limit
     :  LIMIT SP DecimalInteger ;

LIMIT : ('L') ('I') ('M') ('I') ('T')  ;

oC_SortItem
        :  rG_Expression ( SP ( ASCENDING | ASC | DESCENDING | DESC ) )? ;

ASCENDING : ('A') ('S') ('C') ('E') ('N') ('D') ('I') ('N') ('G')  ;

ASC : ('A') ('S') ('C')  ;

DESCENDING : ('D') ('E') ('S') ('C') ('E') ('N') ('D') ('I') ('N') ('G')  ;

DESC : ('D') ('E') ('S') ('C')  ;

oC_Where
     :  WHERE SP oC_ComparisonExpression ;

WHERE : ('W') ('H') ('E') ('R') ('E')  ;

oC_Pattern
       :  oC_PatternPart ( ',' SP oC_PatternPart )* ;

oC_PatternPart
           :  ( oC_Variable SP '=' SP oC_AnonymousPatternPart )
               | oC_AnonymousPatternPart
               ;

oC_AnonymousPatternPart
                    :  oC_PatternElement ;

oC_PatternElement
              :  ( oC_NodePattern ( oC_PatternElementChain )* )
                  | ( oC_PatternElement )
                  ;

oC_NodePattern
           :  '(' ( oC_Variable )? ( oC_NodeLabels )? ( oC_Properties )? ')' ;

oC_PatternElementChain
                   :  oC_RelationshipPattern oC_NodePattern ;

oC_RelationshipPattern
                   :  ( oC_LeftArrowHead oC_Dash oC_RelationshipDetail? oC_Dash oC_RightArrowHead )
                       | ( oC_LeftArrowHead oC_Dash oC_RelationshipDetail? oC_Dash )
                       | ( oC_Dash oC_RelationshipDetail? oC_Dash oC_RightArrowHead )
                       | ( oC_Dash oC_RelationshipDetail? oC_Dash )
                       ;

oC_RelationshipDetail
                  :  '[' ( oC_Variable )? ( oC_RelationshipTypes )? oC_RangeLiteral? ( oC_Properties )? ']' ;

oC_Properties
          :  oC_MapLiteral ;

oC_RelationshipTypes
                 :  ':' oC_RelTypeName ( '|' ':'? oC_RelTypeName )* ;

oC_NodeLabels
          :  oC_NodeLabel ;

oC_NodeLabel
         :  ':' oC_LabelName ;

oC_RangeLiteral
            :  '*' ( DecimalInteger )? ( '..' ( DecimalInteger )? )? ;

oC_LabelName
         :  ( 'label' NonZeroDigit );

oC_RelTypeName
         :  ( 'reltype' NonZeroDigit );

rG_Expression
         :  (oC_Atom | oC_PropertyExpression) ;

rG_SimpleExpression
         :  (oC_Literal | oC_PropertyExpression) ;

/* TODO kill */
oC_Expression
          :  oC_OrExpression ;

oC_OrExpression
            :  oC_XorExpression ( SP OR SP oC_XorExpression )* ;

OR : ('O') ('R')  ;

oC_XorExpression
             :  oC_AndExpression ( SP XOR SP oC_AndExpression )* ;

XOR : ('X') ('O') ('R')  ;

oC_AndExpression
             :  oC_NotExpression ( SP AND SP oC_NotExpression )* ;

AND : ('A') ('N') ('D')  ;

oC_NotExpression
             :  ( NOT SP )* oC_ComparisonExpression ;

NOT : ('N') ('O') ('T')  ;

oC_ComparisonExpression
                    :  (rG_SimpleExpression SP oC_PartialComparisonExpression ) (SP (AND | OR ) SP (rG_SimpleExpression SP oC_PartialComparisonExpression ))* ;

/* TODO these are currently unused */
oC_AddOrSubtractExpression
                       :  oC_MultiplyDivideModuloExpression ( ( SP '+' SP oC_MultiplyDivideModuloExpression ) | ( SP '-' SP oC_MultiplyDivideModuloExpression ) )? ;

oC_MultiplyDivideModuloExpression
                              :  oC_PowerOfExpression ( ( SP '?' SP oC_PowerOfExpression ) | ( SP '/' SP oC_PowerOfExpression ) | ( SP '%' SP oC_PowerOfExpression ) )? ;

oC_PowerOfExpression
                 :  oC_UnaryAddOrSubtractExpression ( SP '^' SP oC_UnaryAddOrSubtractExpression )? ;

oC_UnaryAddOrSubtractExpression
                            :  oC_StringListNullOperatorExpression ;

oC_StringListNullOperatorExpression
                                :  ( oC_ListOperatorExpression | oC_NullOperatorExpression )? ;

oC_ListOperatorExpression
                      :  ( SP '[' rG_Expression ']' )
                          ;

IN : ('I') ('N')  ;

oC_StringOperatorExpression
                        :  ( ( SP STARTS SP WITH ) | ( SP ENDS SP WITH ) | ( SP CONTAINS ) ) SP oC_PropertyOrLabelsExpression ;

STARTS : ('S') ('T') ('A') ('R') ('T') ('S')  ;

ENDS : ('E') ('N') ('D') ('S')  ;

CONTAINS : ('C') ('O') ('N') ('T') ('A') ('I') ('N') ('S')  ;

oC_NullOperatorExpression
                      :  ( SP IS SP NULL )
                          | ( SP IS SP NOT SP NULL )
                          ;

IS : ('I') ('S')  ;

NULL : ('N') ('U') ('L') ('L')  ;

oC_PropertyOrLabelsExpression
                          :  oC_Atom ( oC_PropertyLookup ) ;

oC_Atom
    :  oC_Literal
        /* | oC_CaseExpression */
        /* | ( COUNT '(' SP '*' SP ')' ) */
        /* | oC_ListComprehension */
        /* | oC_PatternComprehension */
        /* | oC_RelationshipsPattern */
        /* | oC_FunctionInvocation */
        | oC_Variable
        ;

COUNT : ('C') ('O') ('U') ('N') ('T')  ;

ANY : ('A') ('N') ('Y')  ;

NONE : ('N') ('O') ('N') ('E')  ;

SINGLE : ('S') ('I') ('N') ('G') ('L') ('E')  ;

oC_Literal
       :  oC_NumberLiteral
           | StringLiteral
           | oC_BooleanLiteral
           | NULL
           /* | oC_MapLiteral */
           | oC_ListLiteral
           ;

oC_BooleanLiteral
              :  TRUE
                  | FALSE
                  ;

TRUE : ('T') ('R') ('U') ('E')  ;

FALSE : ('F') ('A') ('L') ('S') ('E')  ;

oC_ListLiteral
           :  '[' SP ( rG_Expression SP ( ',' SP rG_Expression  SP )* )? ']' ;

oC_PartialComparisonExpression
                           :  ( '=' SP ( rG_SimpleExpression | oC_Literal ) )
                               | ( '<>' SP ( rG_SimpleExpression | oC_Literal ) )
                               | ( '<' SP ( rG_SimpleExpression | oC_Literal ) )
                               | ( '>' SP ( rG_SimpleExpression | oC_Literal ) )
                               | ( '<=' SP ( rG_SimpleExpression | oC_Literal ) )
                               | ( '>=' SP ( rG_SimpleExpression | oC_Literal ) )
                               ;

oC_RelationshipsPattern
                    :  oC_NodePattern ( SP oC_PatternElementChain )+ ;

oC_FilterExpression
                :  oC_IdInColl ( SP oC_Where )? ;

oC_IdInColl
        :  oC_Variable SP IN SP oC_PropertyOrLabelsExpression;

oC_FunctionInvocation
                  :  oC_FunctionName '(' ( DISTINCT SP )? ( rG_SimpleExpression SP ( ',' SP rG_SimpleExpression SP )* )? ')' ;

oC_FunctionName :  oC_SymbolicName  ;

oC_ExplicitProcedureInvocation
                           :  oC_ProcedureName '(' SP ( rG_SimpleExpression SP ( ',' SP rG_SimpleExpression SP )* )? ')' ;

oC_ImplicitProcedureInvocation
                           :  oC_ProcedureName ;

oC_ProcedureResultField
                    :  oC_SymbolicName ;

oC_ProcedureName
             : ( 'algo.bfs'
               | 'algo.pagerank'
               | 'db.idx.fulltext.createnodeindex'
               | 'db.idx.fulltext.drop'
               | 'db.idx.fulltext.querynodes'
               | 'db.labels'
               | 'db.propertykeys'
               | 'db.relationshiptypes'
               | 'dbms.procedures' ) ;


oC_ListComprehension
                 :  '[' SP oC_FilterExpression ( SP '|' SP oC_Expression )? SP ']' ;

oC_PatternComprehension
                    :  '[' SP ( oC_Variable SP '=' SP )? oC_RelationshipsPattern SP ( WHERE SP oC_Expression SP )? '|' SP oC_Expression SP ']' ;

oC_PropertyLookup
              :  '.' ( oC_PropertyKeyName ) ;

oC_CaseExpression
              :  ( ( CASE ( SP oC_CaseAlternatives )+ ) | ( CASE SP rG_SimpleExpression ( SP oC_CaseAlternatives )+ ) ) ( SP ELSE SP rG_SimpleExpression )? SP END ;

CASE : ('C') ('A') ('S') ('E')  ;

ELSE : ('E') ('L') ('S') ('E')  ;

END : ('E') ('N') ('D')  ;

oC_CaseAlternatives
                :  WHEN SP rG_SimpleExpression SP THEN SP rG_SimpleExpression ;

WHEN : ('W') ('H') ('E') ('N')  ;

THEN : ('T') ('H') ('E') ('N')  ;

oC_Variable
        :  oC_SymbolicName ;

StringLiteral
             :  ( '\'' ( StringLiteral_0 )* '\'' )
                 ;

oC_NumberLiteral
             :  oC_DoubleLiteral
                 | oC_IntegerLiteral
                 ;

oC_MapLiteral
          :  '{' ( oC_PropertyKeyName ':' rG_SimpleExpression ( ',' SP oC_PropertyKeyName ':' rG_SimpleExpression )* )? '}' ;

oC_PropertyExpression
                  :  oC_Variable ( oC_PropertyLookup ) ;

oC_PropertyKeyName : ( 'prop' NonZeroDigit );

oC_IntegerLiteral : DecimalInteger ;

DecimalInteger
              :  ZeroDigit
                  | ( NonZeroDigit ( Digit )* )
                  ;

HexLetter
         :  ('A')
             | ('B')
             | ('C')
             | ('D')
             | ('E')
             | ('F')
             ;

HexDigit
        :  Digit
            | HexLetter
            ;

Digit
     :  ZeroDigit
         | NonZeroDigit
         ;

NonZeroDigit
               :  '1'
                   | '2'
                   | '3'
                   | '4'
                   | '5'
                   | '6'
                   | '7'
                   | '8'
                   | '9'
                   ;

ZeroDigit
         :  '0' ;

oC_DoubleLiteral
             :  ExponentDecimalReal
                 | RegularDecimalReal
                 ;

ExponentDecimalReal
                   :  ( ( Digit )+ | ( ( Digit )+ '.' ( Digit )+ ) | ( '.' ( Digit )+ ) ) ('E') '-'? ( Digit )+ ;

RegularDecimalReal
                  :  ( Digit )* '.' ( Digit )+ ;

oC_ReservedWord
            :   ASC
                | ASCENDING
                | BY
                | CREATE
                | DELETE
                | DESC
                | DESCENDING
                | DETACH
                | LIMIT
                | MATCH
                | MERGE
                | ON
                | OPTIONAL
                | ORDER
                | RETURN
                | SET
                | L_SKIP
                | WHERE
                | WITH
                | UNWIND
                | AND
                | AS
                | CONTAINS
                | DISTINCT
                | ENDS
                | IN
                | IS
                | NOT
                | OR
                | STARTS
                | XOR
                | FALSE
                | TRUE
                | NULL
                | CONSTRAINT
                | DO
                | FOR
                | REQUIRE
                | UNIQUE
                | CASE
                | WHEN
                | THEN
                | ELSE
                | END
                | MANDATORY
                | SCALAR
                | OF
                | ADD
                | DROP
                ;

CONSTRAINT : ('C') ('O') ('N') ('S') ('T') ('R') ('A') ('I') ('N') ('T')  ;

DO : ('D') ('O')  ;

FOR : ('F') ('O') ('R')  ;

REQUIRE : ('R') ('E') ('Q') ('U') ('I') ('R') ('E')  ;

UNIQUE : ('U') ('N') ('I') ('Q') ('U') ('E')  ;

MANDATORY : ('M') ('A') ('N') ('D') ('A') ('T') ('O') ('R') ('Y')  ;

SCALAR : ('S') ('C') ('A') ('L') ('A') ('R')  ;

OF : ('O') ('F')  ;

ADD : ('A') ('D') ('D')  ;

DROP : ('D') ('R') ('O') ('P')  ;

oC_SymbolicName
            :  EscapedSymbolicName
                ;

/**
 * Any character except "`", enclosed within `backticks`. Backticks are escaped with double backticks.
 */
EscapedSymbolicName
                   :  ( ( EscapedSymbolicName_0 ) ) ;

SP
  :  ( WHITESPACE ) ;

WHITESPACE
          :  SPACE
              ;

oC_LeftArrowHead
             :  '<'
                 ;

oC_RightArrowHead
              :  '>'
                  ;

oC_Dash
    :  '-'
        ;


fragment EscapedSymbolicName_0 : ( 'var'[1-9] ) ;

fragment SPACE : [ ] ;

fragment StringLiteral_0 : ('L') ('I') ('T');

