module MetaC-CSP/types

imports

  signatures/MetaC-CSP-sig
  BaseC/desugar/constructors

type rules

  CSPChanWrite(_, chan, expr):-
    where
          chan: CSPChan(Type(_, vt))
      and expr : et
      and (et <is-assignable: vt)
        else error $[Can't write value of type: [et] to channel of type [vt]] on expr

  CSPChanRead(chan, dest): vt
    where
          chan: CSPChan(Type(_, vt))
      and dest : dt
      and (vt <is-assignable: dt)
        else error $[Can't assign a value from the channel with type: [vt] to variable of type [dt]] on dest

  CSPAnonChanRead(chan, name): vt
    where
      chan: CSPChan(Type(_, vt))
