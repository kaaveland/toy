-module(problems).

% P1
get_last([Head]) ->
    Head;
get_last([_ | Tail]) ->
    get_last(Tail).

% P2

get_secondlast([Elem | [_]]) ->
    Elem;
get_secondlast([_ | Tail]) ->
    get_secondlast(Tail).

% P3

get_nth(N, [Head | _]) when N == 0 ->
    Head;
get_nth(N, [_ | Tail]) ->
    get_nth(N - 1, Tail).

% P4

get_length(Sofar, []) ->
    Sofar;
get_length(Sofar, [_ | Tail]) ->
    get_length(Sofar + 1, Tail).
get_length(List) ->
    get_length(0, List).

% P5

get_reverse(Sofar, []) ->
    Sofar;
get_reverse(Sofar, [Head | Tail]) ->
    get_reverse([Head | Sofar], Tail).
get_reverse(List) ->
    get_reverse([], List).

% P6

take_to(_, Sofar, []) ->
    {get_reverse(Sofar), []};
take_to(Index, Sofar, Rest) when Index == 0 ->
    {get_reverse(Sofar), Rest};
take_to(Index, Sofar, [Head | Tail]) ->
    take_to(Index - 1, [Head | Sofar], Tail).
take_to(Index, List) ->
    take_to(Index, [], List).

split_middle(List) ->
    SplitAt = get_length(List) div 2,
    take_to(SplitAt, List).

but_last([_]) ->
    [];
but_last([Head | Tail]) ->
    [Head | but_last(Tail)].

but_first([_ | Tail]) ->
    Tail.

pairwise_equal([], [_ | _]) -> false;
pairwise_equal([_ | _], []) -> false;
pairwise_equal([], []) -> true;
pairwise_equal([X | Xs], [Y | Ys]) when X == Y ->
    pairwise_equal(Xs, Ys);
pairwise_equal(_, _) -> false.

palindrome_split(Xs, Ys) ->
    Xlength = get_length(Xs),
    Ylength = get_length(Ys),
    if Xlength > Ylength ->
            {but_first(Xs), Ys};
       Ylength > Xlength ->
            {Xs, but_first(Ys)};
       true ->
            {Xs, Ys}
    end.
        
is_palindrome(List) ->
    {First, Second} = split_middle(List),
    {Xs, Ys} = palindrome_split(First, Second),
    pairwise_equal(Xs, Ys).
    
easier_is_palindrome(List) ->
    List == get_reverse(List).

% P7

get_flat([]) ->
    [];
get_flat([ Head | Tail ]) when is_list(Head) ->
    get_flat(Head) ++ get_flat(Tail);
get_flat([ Head | Tail ]) ->
    [Head | get_flat(Tail)].

% P8, P9

get_groups(List) ->
    get_groups(List, []).
get_groups([], []) ->
    [];
get_groups([], Ys) ->
    [Ys];
get_groups([Head | Tail], []) ->
    get_groups(Tail, [Head]);
get_groups([Head | Tail], Vs) when Head == hd(Vs) ->
    get_groups(Tail, [Head | Vs]);
get_groups([Head | Tail], Vs) ->
    [Vs] ++ get_groups(Tail, [Head]).

map_list(_, []) ->
    [];
map_list(Function, [Head | Tail]) ->
    [Function(Head) | map_list(Function, Tail)].

compress(List) ->
    Groups = get_groups(List),
    map_list(fun hd/1, Groups).

% P10

run_length_encode(List) ->
    Groups = get_groups(List),
    map_list(fun (X) -> {get_length(X), hd(X)} end, Groups).

% P11

encode_tuple({Count, Element}) when Count == 1 ->
    Element;
encode_tuple({Count, Element}) ->
    {Count, Element}.

modified_run_length_encode(List) ->
    Rle = run_length_encode(List),
    map_list(fun encode_tuple/1, Rle).

% P12

get_repeated(0, _) ->
    [];
get_repeated(N, X) ->
    [X | get_repeated(N - 1, X)].

decode_tuple({Count, Element}) ->
    get_repeated(Count, Element);
decode_tuple(Element) -> 
    [Element].

decode_rle(Rle) ->
    Decoded = map_list(fun decode_tuple/1, Rle),
    get_flat(Decoded).

% P13

new_rle([], Current, Sofar) ->
    [encode_tuple({Sofar, Current})];
new_rle([Head | Tail], Current, Sofar) when Head == Current ->
    new_rle(Tail, Head, Sofar + 1);
new_rle([Head | Tail], Current, Sofar) ->
    [encode_tuple({Sofar, Current}) | new_rle(Tail, Head, 1)].
new_rle([]) ->
    [];
new_rle([Head | Tail]) ->
    new_rle(Tail, Head, 1).

% P14/P15

dupli(List, Count) ->
    get_flat(map_list(fun (X) -> get_repeated(Count, X) end, List)).
                               
dupli(List) ->
    dupli(List, 2).

% P16

drop_every(_, _, []) ->
    [];
drop_every(Count, N, [_ | Tail]) when Count == N ->
    drop_every(1, N, Tail);
drop_every(Count, N, [Head | Tail]) ->
    [Head | drop_every(Count + 1, N, Tail)].
drop_every(N, List) ->
    drop_every(1, N, List).

% P17

split_with_length(0, Stored, Rest) ->
    {get_reverse(Stored), Rest};
split_with_length(N, Stored, [Head | Tail]) ->
    split_with_length(N - 1, [Head | Stored], Tail).
split_with_length(N, List) ->
    split_with_length(N, [], List).

% P18 - using 0-indexing, because 1-indexing is a sin
% Not inclusive end index

slice(List, Start, End) ->
    {_, Keep} = split_with_length(Start, List),
    {Result, _} = split_with_length(End - Start - 1, Keep),
    Result.

% P19

rotate(List, N) ->
    {Head, Tail} = split_with_length(N, List),
    Tail ++ Head.

% P20

remove_at(List, Index) ->
    {Head, Tail} = split_with_length(Index, List),
    Head ++ tl(Tail).

% P21

insert_at(List, Index, Element) ->
    {Head, Tail} = split_with_length(Index, List),
    Head ++ [Element | Tail].

% P22

integer_range(From, To, Acumulator) when From < To ->
    integer_range(From + 1, To, [From | Acumulator]);
integer_range(_, _, Acumulator) ->
    get_reverse(Acumulator).
integer_range(From, To) ->
    integer_range(From, To, []).

% P23

rnd_select_one(List) ->
    Index = random:uniform(get_length(List)) - 1,
    {remove_at(List, Index), get_nth(Index, List)}.

rnd_select(_, N, A) when N == 0 ->
    get_reverse(A);
rnd_select(List, N, A) ->
    {Rest, Element} = rnd_select_one(List),
    rnd_select(Rest, N - 1, [Element | A]).
rnd_select(List, N) ->
    rnd_select(List, N, []).

% P24

lotto_draw(N, L) ->
    Range = integer_range(1, L),
    rnd_select(Range, N).

% P25

rnd_permutation(List) ->
    rnd_select(List, get_length(List)).

% P26

prepend(Element, List) ->
    [Element | List].

for_each(_, [], _) ->
    [];
for_each(Function, [Head | Tail], Index) ->
    [Function(Index, Head) | for_each(Function, Tail, Index + 1)].
for_each(Function, List) ->
    for_each(Function, List, 0).

flatten([]) ->
    [];
flatten([Head | Tail]) ->
    Head ++ flatten(Tail).

combine(Index, Element, List, N) ->
    {_, [_ | Rest]} = split_with_length(Index, List),
    Combs = combinations(N, Rest),
    map_list(fun(X) -> [Element | X] end, Combs).

combinations(0, _) ->
    [];
combinations(1, List) ->
    map_list(fun(X) -> [X] end, List);
combinations(_, []) ->
    [];
combinations(N, List) ->
    flatten(for_each(fun(Index, Element) ->
                             combine(Index, Element, List, N - 1) end, List)).

% P27

% P28

merge_by([], Ys, _) ->
    Ys;
merge_by(Xs, [], _) ->
    Xs;
merge_by([X | Xs], [Y | Ys], Key) ->
    Cmp = Key(X, Y),
    if Cmp =< 0 ->
            [X | merge_by(Xs, [Y | Ys], Key)];
       true ->
            [Y | merge_by([X | Xs], Ys, Key)]
    end.

merge_sort_by([], _) ->
    [];
merge_sort_by([X], _) ->
    [X];
merge_sort_by(Xs, Key) ->
    {Head, Tail} = split_with_length(get_length(Xs) div 2, Xs),
    merge_by(merge_sort_by(Head, Key), merge_sort_by(Tail, Key), Key).

merge_sort(Xs) ->
    merge_sort_by(Xs, fun(X, Y) -> X - Y end).
                               
lsort(Xs) ->
    merge_sort_by(Xs, fun(X, Y) -> get_length(X) - get_length(Y) end).

fold_list(_, [], Init) ->
    Init;
fold_list(Fun, [X | Xs], Init) ->
    fold_list(Fun, Xs, Fun(X, Init)).
    
count_where(Xs, Condition) ->
    fold_list(fun (ListElem, Count) ->
                      case Condition(ListElem) of 
                          true -> Count + 1;
                          false -> Count
                      end end, Xs, 0).

count_of_length(X, Xs) ->                              
    count_where(Xs, fun(Y) -> get_length(X) == get_length(Y) end).

count_comparator(Xs) ->
    fun(X, Y) ->
            count_of_length(X, Xs) - count_of_length(Y, Xs) end.

llsort(Xs) ->
    merge_sort_by(Xs, count_comparator(Xs)).
                              
