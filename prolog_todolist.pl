% Eye bank management system
% Database to store cornea
:- dynamic cornea/5.

% Start the eye bank management system
start :-
    write('Eye bank management system'), nl,
    display_commands,
    process_commands.

% Display available commands
display_commands :-
    nl,
    write('Available commands:'), nl,
    write('   1. add         - Add a new cornea'), nl,
    write('   2. display     - Display all cornea'), nl,
    write('   3. update      - Update a cornea'), nl,
    write('   4. test        - Mark a cornea as tested'), nl,
    write('   5. discard     - Discard a cornea'), nl,
    write('   6. distribute  - Mark a cornea as distributed'), nl,
    write('   7. exit        - Exit Eye bank management system'), nl,
    nl.

% Process user commands
process_commands :-
    repeat,
    nl,
    write('Enter a command: '),
    read(Command),
    execute_command(Command),
    (Command == exit ; Command == end_of_file).

% Execute the user command
execute_command(1) :-
    add_cornea.
    
execute_command(2) :-
    display_cornea.
    
execute_command(3) :-
    update_cornea.
    
execute_command(4) :-
    test_cornea.
    
execute_command(5) :-
    discard_cornea.
    
execute_command(6) :-
    distribute_cornea.
    
execute_command(7) :-
    write('Exiting from the system...'), nl.

% Add a new cornea
add_cornea :-
    write('Enter lot number: '),
    read(LotNumber),
    write('Enter iris color: '),
    read(IrisColor),
    write('Enter collection date: '),
    read(CollectionDate),
    assertz(cornea(LotNumber, IrisColor, CollectionDate, incomplete, not_distributed)),
    write('Cornea added successfully.'), nl.

% Discard a cornea
discard_cornea :-
    write('Enter lot number to remove: '),
    read(LotNumber),
    retract(cornea(LotNumber, _, _, _, _)),
    write('Cornea discarded successfully.'), nl.
% Update a cornea
update_cornea :-
    write('Enter lot number to update: '),
    read(LotNumber),
    retract(cornea(LotNumber, _, _, _, _)),
    write('Enter updated iris color: '),
    read(IrisColor),
    write('Enter updated collection date: '),
    read(CollectionDate),
    assertz(cornea(LotNumber, IrisColor, CollectionDate, incomplete, not_distributed)),
    write('Cornea updated successfully.'), nl.

% Mark a cornea as tested
test_cornea :-
    write('Enter lot number to mark as tested: '),
    read(LotNumber),
    cornea(LotNumber, IrisColor, CollectionDate, TestStatus, DistributionStatus),
    retract(cornea(LotNumber, IrisColor, CollectionDate, TestStatus, DistributionStatus)),
    assertz(cornea(LotNumber, IrisColor, CollectionDate, complete, DistributionStatus)),
    write('Cornea marked as tested successfully.'), nl.

% Mark a cornea as distributed
distribute_cornea :-
    write('Enter lot number to mark as distributed: '),
    read(LotNumber),
    retract(cornea(LotNumber, IrisColor, CollectionDate, TestStatus, _)),
    assertz(cornea(LotNumber, IrisColor, CollectionDate, TestStatus, distributed)),
    write('Cornea marked as distributed successfully.'), nl.
% Display all cornea
display_cornea :-
    write('Cornea:'), nl,
    write('┌─────────────┬────────────┬──────────────────┬─────────┬──────────────┐'), nl,
    write('│ Lot Number  │ Iris Color │ Collection Date  │ Status  │ Distribution │'), nl,
    write('├─────────────┼────────────┼──────────────────┼─────────┼──────────────┤'), nl,
    cornea(LotNumber, IrisColor, CollectionDate, TestStatus, DistributionStatus),
    format('│ ~w        │ ~w         │ ~w      │ ~w     │ ~w           │', [LotNumber, IrisColor, CollectionDate, TestStatus, DistributionStatus]), nl,
    fail.
display_cornea :-
    write('└─────────────┴────────────┴──────────────────┴─────────┴──────────────┘'), nl.
display_cornea :- nl.
display_cornea :- nl.

% Entry point to start the eye bank management system
:- initialization(start).
