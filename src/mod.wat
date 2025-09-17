(module
  ;; (import "./log.ts" "log" (func $log (param i32)))
  ;; (import "./log.ts" "spy" (func $spy (param i32) (result i32)))

  (memory (export "memory") 1)

  (global $alloc (mut i32) (i32.const 1024))
  (func $alloc (param $size i32) (result i32)
    (loop $loop (if
      (i32.gt_u
        (i32.add (global.get $alloc) (local.get $size))
        (i32.mul (memory.size) (i32.const 65536))
      )
    (then
      (memory.grow (i32.const 1))
      (br $loop)
    )))

    (;;) (global.get $alloc)
    (global.set $alloc (i32.add (global.get $alloc) (local.get $size)))
  )

  (func $set_alloc (param $addr i32) (result)
    (global.set $alloc (local.get $addr))
  )

  (func $get_alloc (result i32)
    (;;) (global.get $alloc)
  )

  (global $mem_end (mut i32) (i32.const 256))
  (func $mem_set (param $expr i32) (result i32)
    ;; (out_of_memory)

    (if (i32.ge_u (global.get $mem_end) (i32.const 1024)) (then
      (return (i32.const 1))
    ))

    (i32.store (global.get $mem_end) (local.get $expr))
    (global.set $mem_end (i32.add (global.get $mem_end) (i32.const 4)))

    (;;) (i32.const 0)
  )

  (func $mem_get (param $token i32) (result i32)
    ;; (mem_addr)
    (local $i i32)
    (local $len i32)
    (local $t i32)

    (local.set $i (i32.const 256))
    (;;) (i32.sub
      (i32.add (local.get $token) (i32.const 5))
      (i32.add (local.get $token) (i32.const 1))
    )
    (local.set $len (;;))
    (loop $next (if (i32.lt_u (local.get $i) (global.get $mem_end)) (then
      (;;) (i32.load (local.get $i))
      (;;) (i32.load (i32.add (;;) (i32.const 2)))
      (local.set $t (;;))
      (;;) (i32.sub
        (i32.add (local.get $t) (i32.const 5))
        (i32.add (local.get $t) (i32.const 1))
      )
      (if (i32.eq (;;) (local.get $len)) (then
        (if (call $eq_token (local.get $t) (local.get $token)) (then
          (return (i32.load (local.get $i)))
        ))
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 4)))
      (br $next)
    )))

    (;;) (i32.const 0)
  )

  (func $eq_token (param $t1 i32) (param $t2 i32) (result i32)
    ;; (equal)
    (local $i i32)
    (local $j i32)
    (local $len i32)

    (local.set $i (i32.load (i32.add (local.get $t1) (i32.const 1))))
    (local.set $j (i32.load (i32.add (local.get $t2) (i32.const 1))))
    (local.set $len (i32.load (i32.add (local.get $t1) (i32.const 5))))
    (loop $next (if (i32.lt_u (local.get $i) (local.get $len)) (then
      (if (i32.ne
        (i32.load8_u (local.get $i))
        (i32.load8_u (local.get $j))
      ) (then
        (return (i32.const 0))
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (local.set $j (i32.add (local.get $j) (i32.const 1)))
      (br $next)
    )))

    (;;) (i32.const 1)
  )

  (data (i32.const 0)   "\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00")
  (data (i32.const 16)  "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 32)  "\01\34\00\00\00\00\00\00\08\09\04\02\0c\03\00\05")
  (data (i32.const 48)  "\64\64\64\64\64\64\64\64\64\64\07\06\36\32\38\00")
  (data (i32.const 64)  "\00\65\65\65\65\65\65\65\65\65\65\65\65\65\65\65")
  (data (i32.const 80)  "\65\65\65\65\65\65\65\65\65\65\65\00\00\00\00\00")
  (data (i32.const 96)  "\00\65\65\65\65\65\65\65\65\65\65\65\65\65\65\65")
  (data (i32.const 112) "\65\65\65\65\65\65\65\65\65\65\65\0a\00\0b\00\00")
  (data (i32.const 128) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 144) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 160) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 176) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 192) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 208) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 224) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 240) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")

  (func $scan (param $i i32) (param $len i32) (result i32 i32)
    ;; (has_error, addr)
    (local $o i32)
    (local $char i32)

    (;;) (local.tee $len (i32.add (local.get $i) (local.get $len)))
    (local.set $o (;;))

    (loop $next (if (i32.lt_u (local.get $i) (local.get $len)) (then
      (;;) (local.tee $char (i32.load8_u (i32.load8_u (local.get $i))))
      (if (i32.eqz (;;)) (then
        (return (i32.const 1) (local.get $i))
      ))
      (if (i32.eq (local.get $char) (i32.const 1)) (then
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $next)
      ))
      (if (i32.ge_u (local.get $char) (i32.const 2)) (then
        (if (i32.lt_u (local.get $char) (i32.const 50)) (then
          (i32.store8 (local.get $o) (local.get $char))
          (i32.store (i32.add (local.get $o) (i32.const 1)) (local.get $i))
          (i32.store
            (i32.add (local.get $o) (i32.const 5))
            (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          )
          (local.set $o (i32.add (local.get $o) (i32.const 9)))
          (br $next)
        ))
      ))
      (if (i32.ge_u (local.get $char) (i32.const 50)) (then
        (if (i32.lt_u (local.get $char) (i32.const 100)) (then
          (i32.store (i32.add (local.get $o) (i32.const 1)) (local.get $i))
          (;;) (i32.load8_u (i32.add (local.get $i) (i32.const 1)))
          (if (i32.eq (i32.load8_u (;;)) (i32.const 50)) (then
            (i32.store8
              (local.get $o)
              (i32.add (local.get $char) (i32.const 1))
            )
            (i32.store
              (i32.add (local.get $o) (i32.const 5))
              (local.tee $i (i32.add (local.get $i) (i32.const 2)))
            )
          ) (else
          (i32.store8 (local.get $o) (local.get $char))
          (i32.store
            (i32.add (local.get $o) (i32.const 5))
            (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          )
          ))
          (local.set $o (i32.add (local.get $o) (i32.const 9)))
          (br $next)
        ))
      ))
      (if (i32.eq (local.get $char) (i32.const 100)) (then
        (i32.store8 (local.get $o) (local.get $char))
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 1)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (loop $x
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (br_if $x (i32.eq (i32.load8_u (i32.load8_u (;;))) (i32.const 100)))
        )
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (local.set $o (i32.add (local.get $o) (i32.const 4)))
        (br $next)
      ))
      (if (i32.eq (local.get $char) (i32.const 101)) (then
        (;keyword;) (local.get $o)

        (i32.store8 (local.get $o) (local.get $char))
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 1)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (loop $x
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (;;) (local.tee $char (i32.load8_u (i32.load8_u (;;))))
          (br_if $x (i32.eq (;;) (i32.const 101)))
          (br_if $x (i32.eq (local.get $char) (i32.const 100)))
        )
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (local.set $o (i32.add (local.get $o) (i32.const 4)))

        (call $keyword (;keyword;))
        (br $next)
      ))
      unreachable
    )))
    (;;) (i32.const 0)
    (;;) (local.get $o)
  )

  (func $keyword (param $t i32)
    (local $i i32)
    (local $len i32)

    (local.set $len (i32.load (i32.add (local.get $t) (i32.const 5))))
    (;;) (local.tee $i (i32.load (i32.add (local.get $t) (i32.const 1))))
    (if (i32.eq (i32.load8_u (;;)) (i32.const 101)) (then
      (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 108)) (then
        (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
        (if (i32.eq (i32.load8_u (;;)) (i32.const 115)) (then
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (if (i32.eq (i32.load8_u (;;)) (i32.const 101)) (then
            (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
            (if (i32.eq (;;) (local.get $len)) (then
              (i32.store8 (local.get $t) (i32.const 154))
            ))
          ))
        ))
      ) (else (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 120)) (then
        (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
        (if (i32.eq (i32.load8_u (;;)) (i32.const 112)) (then
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (if (i32.eq (i32.load8_u (;;)) (i32.const 111)) (then
            (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
            (if (i32.eq (i32.load8_u (;;)) (i32.const 114)) (then
              (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
              (if (i32.eq (i32.load8_u (;;)) (i32.const 116)) (then
                (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
                (if (i32.eq (;;) (local.get $len)) (then
                  (i32.store8 (local.get $t) (i32.const 152))
                ))
              ))
            ))
          ))
        ))
      ))))
    ) (else (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 102)) (then
      (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 117)) (then
        (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
        (if (i32.eq (i32.load8_u (;;)) (i32.const 110)) (then
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (if (i32.eq (i32.load8_u (;;)) (i32.const 99)) (then
            (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
            (if (i32.eq (;;) (local.get $len)) (then
              (i32.store8 (local.get $t) (i32.const 151))
            ))
          ))
        ))
      ))
    ) (else (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 105)) (then
      (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 51)) (then
        (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
        (if (i32.eq (i32.load8_u (;;)) (i32.const 50)) (then
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (if (i32.eq (;;) (local.get $len)) (then
            (i32.store8 (local.get $t) (i32.const 200))
          ))
        ))
      ) (else (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 102)) (then
        (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
        (if (i32.eq (;;) (local.get $len)) (then
          (i32.store8 (local.get $t) (i32.const 153))
        ))
      ))))
    ) (else (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 118)) (then
      (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 97)) (then
        (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
        (if (i32.eq (i32.load8_u (;;)) (i32.const 114)) (then
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (if (i32.eq (;;) (local.get $len)) (then
            (i32.store8 (local.get $t) (i32.const 150))
          ))
        ))
      ))
    ))))))))
  )

  (func $type (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, type)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 7)) (then
      (return (i32.const 3) (local.get $i))
    ))
    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))

    (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 200)) (then
      (return (i32.add (local.get $i) (i32.const 9)) (i32.const 2))
    ))

    (;;) (i32.const 3)
    (;;) (local.get $i)
  )

  (func $identifier (param $i i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)
    (local $type i32)
    (local $assignable i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 101)) (then
      (return (i32.const 0) (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $expr (call $mem_get (local.get $i)))
    (if (i32.eqz (;;)) (then
      (return (i32.const 0) (i32.const 7) (local.get $i))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 6)))
    (i32.store8 (;;) (i32.const 8)) ;; id

    (if (i32.eq (i32.load8_u (local.get $expr)) (i32.const 6)) (then
      (;;) (i32.load (i32.add (local.get $expr) (i32.const 6)))
      (;;) (i32.load8_u (i32.add (;;) (i32.const 1)))
      (local.set $type (;;))
      (local.set $assignable (i32.const 1))
    ) (else (if (i32.eq (i32.load8_u (local.get $expr)) (i32.const 10)) (then
      (;;) (i32.load8_u (i32.add (local.get $expr) (i32.const 10)))
      (local.set $type (;;))
      (local.set $assignable (i32.const 0))
    ) (else (if (i32.eq (i32.load8_u (local.get $expr)) (i32.const 11)) (then
      (;;) (i32.load8_u (i32.add (local.get $expr) (i32.const 1)))
      (local.set $type (;;))
      (local.set $assignable (i32.const 1))
    ) (else
      unreachable
    ))))))
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (local.get $type))
      ;; type

    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; token_addr

    (;;) (local.get $assignable)
    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $call (param $i i32) (param $len i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)
    (local $assignable i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 101)) (then
      (return (i32.const 0) (i32.const 3) (local.get $i))
    ))
    (;;) (;;) (;;) (call $identifier (local.get $i))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (local.set $assignable (;;))
    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 8)) (then
      (return (local.get $assignable) (local.get $i) (local.get $expr))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 10)))
    (i32.store8 (;;) (i32.const 12)) ;; id
    (i32.store8
      (i32.add (local.get $addr) (i32.const 1))
      (i32.load8_u (i32.add (local.get $expr) (i32.const 1)))
    ) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $expr))
      ;; identifier_addr

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (call $node
      (local.get $i)
      (local.get $len)
      (i32.const 9)
      (i32.const 4)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $expr))
      ;; parameter_node_addr

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 9)) (then
      (return (i32.const 0) (i32.const 3) (local.get $i))
    ))

    (;;) (i32.const 0)
    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $primary (param $i i32) (param $len i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 100)) (then
      (;;) (;;) (;;) (call $call (local.get $i) (local.get $len))
      (return (;;) (;;) (;;))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 6)))
    (i32.store8 (;;) (i32.const 1)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 2)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; token_addr

    (;;) (i32.const 0)
    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $unary (param $i i32) (param $len i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 2)) (then
      (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 3)) (then
        (;;) (;;) (;;) (call $primary (local.get $i) (local.get $len))
        (return (;;) (;;) (;;))
      ))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 10)))
    (i32.store8 (;;) (i32.const 2)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 2)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; token_addr

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (;;) (call $unary (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 2)) (then
      (return (i32.const 0) (i32.const 9) (local.get $expr))
    ))

    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $expr))
      ;; expr_addr

    (;;) (i32.const 0)
    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $factor (param $i i32) (param $len i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)
    (local $assignable i32)

    (;;) (;;) (;;) (call $unary (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (local.set $assignable (;;))

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 4)) (then
      (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 5)) (then
        (return (local.get $assignable) (local.get $i) (local.get $expr))
      ))
    ))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 2)) (then
      (return (i32.const 0) (i32.const 9) (local.get $expr))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 14)))
    (i32.store8 (;;) (i32.const 3)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 2)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $expr))
      ;; expr_addr1
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $i))
      ;; token_addr

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (;;) (call $factor (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 2)) (then
      (return (i32.const 0) (i32.const 9) (local.get $expr))
    ))

    (i32.store (i32.add (local.get $addr) (i32.const 10)) (local.get $expr))
      ;; expr_addr2

    (;;) (i32.const 0)
    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $term (param $i i32) (param $len i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)
    (local $assignable i32)

    (;;) (;;) (;;) (call $factor (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (local.set $assignable (;;))

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 2)) (then
      (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 3)) (then
        (return (local.get $assignable) (local.get $i) (local.get $expr))
      ))
    ))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 2)) (then
      (return (i32.const 0) (i32.const 9) (local.get $expr))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 14)))
    (i32.store8 (;;) (i32.const 4)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 2)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $expr))
      ;; expr_addr1
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $i))
      ;; token_addr

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (;;) (call $term (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 2)) (then
      (return (i32.const 0) (i32.const 9) (local.get $expr))
    ))

    (i32.store (i32.add (local.get $addr) (i32.const 10)) (local.get $expr))
      ;; expr_addr2

    (;;) (i32.const 0)
    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $compare (param $i i32) (param $len i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)
    (local $type i32)
    (local $assignable i32)

    (;;) (;;) (;;) (call $term (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (local.set $assignable (;;))

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (local.set $type (i32.load8_u (;;)))
    (if (i32.and
      (i32.ne (i32.load8_u (local.get $i)) (i32.const 51))
      (i32.ne (i32.load8_u (local.get $i)) (i32.const 53))
    ) (then
      (if (i32.or
        (i32.lt_u (i32.load8_u (local.get $i)) (i32.const 54))
        (i32.gt_u (i32.load8_u (local.get $i)) (i32.const 57))
      ) (then
        (return (local.get $assignable) (local.get $i) (local.get $expr))
      ) (else (if (i32.ne (local.get $type) (i32.const 2)) (then
        (return (i32.const 0) (i32.const 9) (local.get $expr))
      ))))
    ) (else (if (i32.and
      (i32.ne (local.get $type) (i32.const 1))
      (i32.ne (local.get $type) (i32.const 2))
    ) (then
      (return (i32.const 0) (i32.const 9) (local.get $expr))
    ))))

    (;;) (local.tee $addr (call $alloc (i32.const 14)))
    (i32.store8 (;;) (i32.const 9)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 1)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $expr))
      ;; expr_addr1
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $i))
      ;; token_addr

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 0) (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (;;) (call $compare (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (i32.const 0) (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (local.get $type)) (then
      (return (i32.const 0) (i32.const 9) (local.get $expr))
    ))

    (i32.store (i32.add (local.get $addr) (i32.const 10)) (local.get $expr))
      ;; expr_addr2

    (;;) (i32.const 0)
    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $expr (param $i i32) (param $len i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)

    (;;) (;;) (;;) (call $compare (local.get $i) (local.get $len))
  )

  (func $assign (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)
    (local $type i32)

    (;;) (;;) (;;) (call $expr (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (if (i32.eqz (;;)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 50)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (local.set $type (i32.load8_u (;;)))

    (;;) (local.tee $addr (call $alloc (i32.const 10)))
    (i32.store8 (;;) (i32.const 7)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 0)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $expr))
      ;; expr_addr1

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (;;) (call $expr (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (local.get $type)) (then
      (return (i32.const 9) (local.get $expr))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $expr))
      ;; expr_addr2

    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $var (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 150)) (then
      (;;) (;;) (call $assign (local.get $i) (local.get $len))
      (return (;;) (;;))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 10)))
    (i32.store8 (;;) (i32.const 6)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 0)) ;; type

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 101)) (then
      (return (i32.const 3) (local.get $i))
    ))
    (if (call $mem_get (local.get $i)) (then
      (return (i32.const 6) (local.get $i))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; identifier_token_addr
    (if (call $mem_set (local.get $addr)) (then
      (return (i32.const 8) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 50)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (;;) (call $expr (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 2)) (then
      (return (i32.const 9) (local.get $expr))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $expr))
      ;; expr_addr

    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $if (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 153)) (then
      (;;) (;;) (call $var (local.get $i) (local.get $len))
      (return (;;) (;;))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 14)))
    (i32.store8 (;;) (i32.const 13)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 0)) ;; type

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (;;) (call $expr (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (;;) (i32.add (local.get $expr) (i32.const 1))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 1)) (then
      (return (i32.const 9) (local.get $expr))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $expr))
      ;; conditional_addr

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 10)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (call $node
      (local.get $i)
      (local.get $len)
      (i32.const 11)
      (i32.const 1)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $expr))
      ;; true_node_addr

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 11)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 154)) (then
      (i32.store (i32.add (local.get $addr) (i32.const 10)) (i32.const 0))
        ;; false_node_addr
      (return (i32.add (local.get $i) (i32.const 9)) (local.get $addr))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 10)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (call $node
      (local.get $i)
      (local.get $len)
      (i32.const 11)
      (i32.const 1)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 10)) (local.get $expr))
      ;; false_node_addr

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 11)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $stmt (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)

    (;;) (;;) (call $if (local.get $i) (local.get $len))
    (local.set $addr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $addr))
    ))

    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 13)) (then
      (return (local.get $i) (local.get $addr))
    ))
    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 6)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $para (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $expr i32)

    (;;) (;;) (call $expr (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (drop (;;))
    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))

    (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 12)) (then
      (return (i32.add (local.get $i) (i32.const 9)) (local.get $expr))
    ))
    (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 9)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (;;) (i32.const 3)
    (;;) (local.get $i)
  )

  (func $argu (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 101)) (then
      (return (i32.const 3) (local.get $i))
    ))
    (if (call $mem_get (local.get $i)) (then
      (return (i32.const 6) (local.get $i))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 6)))
    (i32.store8 (;;) (i32.const 11)) ;; id
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; identifier_token_addr
    (if (call $mem_set (local.get $addr)) (then
      (return (i32.const 8) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (call $type (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (local.get $expr))
      ;; type

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 12)) (then
      (return (i32.add (local.get $i) (i32.const 9)) (local.get $addr))
    ))
    (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 9)) (then
      (return (local.get $i) (local.get $addr))
    ))

    (;;) (i32.const 3)
    (;;) (local.get $i)
  )

  (func $func (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)
    (local $exported i32)

    (local.set $exported (i32.const 0))
    (if (i32.eq (i32.load8_u (local.get $i)) (i32.const 152)) (then
      (local.set $exported (i32.const 1))
      (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
      (if (i32.ge_u (;;) (local.get $len)) (then
        (return (i32.const 2) (local.get $i))
      ))
    ))

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 151)) (then
      (return (i32.const 3) (local.get $i))
    ))
    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 101)) (then
      (return (i32.const 3) (local.get $i))
    ))
    (if (call $mem_get (local.get $i)) (then
      (return (i32.const 6) (local.get $i))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 16)))
    (i32.store8 (;;) (i32.const 10)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 0)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; identifier_token_addr
    (if (call $mem_set (local.get $addr)) (then
      (return (i32.const 8) (local.get $i))
    ))
    (;mem_end;) (global.get $mem_end)

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 8)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (call $node
      (local.get $i)
      (local.get $len)
      (i32.const 9)
      (i32.const 3)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $len))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 6)) (local.get $expr))
      ;; argument_node_addr

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 9)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (call $type (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (i32.store8 (i32.add (local.get $addr) (i32.const 10)) (local.get $expr))
      ;; return_type

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 10)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $i (i32.add (local.get $i) (i32.const 9)))
    (if (i32.ge_u (;;) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (;;) (;;) (call $node
      (local.get $i)
      (local.get $len)
      (i32.const 11)
      (i32.const 1)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 11)) (local.get $expr))
      ;; body_node_addr

    ;; todo: count body_node_addr i32 results

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 11)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (i32.store8
      (i32.add (local.get $addr) (i32.const 15))
      (local.get $exported)
    ) ;; exported

    (global.set $mem_end (;mem_end;))
    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $level (param $i i32) (param $len i32) (param $l i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)

    (if (i32.eq (local.get $l) (i32.const 1)) (then
      (;;) (;;) (call $stmt (local.get $i) (local.get $len))
      (return (;;) (;;))
    ))
    (if (i32.eq (local.get $l) (i32.const 2)) (then
      (;;) (;;) (call $func (local.get $i) (local.get $len))
      (return (;;) (;;))
    ))
    (if (i32.eq (local.get $l) (i32.const 3)) (then
      (;;) (;;) (call $argu (local.get $i) (local.get $len))
      (return (;;) (;;))
    ))
    (if (i32.eq (local.get $l) (i32.const 4)) (then
      (;;) (;;) (call $para (local.get $i) (local.get $len))
      (return (;;) (;;))
    ))
    unreachable
  )

  (func $node
    (param $i i32)
    (param $len i32)
    (param $t_id i32)
    (param $l i32)
    (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (local.get $i) (i32.const 0))
    ))
    (if (i32.eq (i32.load8_u (local.get $i)) (local.get $t_id)) (then
      (return (local.get $i) (i32.const 0))
    ))

    (;;) (;;) (call $level (local.get $i) (local.get $len) (local.get $l))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 8)))
    (i32.store (i32.add (;;) (i32.const 4)) (local.get $expr)) ;; expr_addr

    (;;) (;;) (call $node
      (local.get $i)
      (local.get $len)
      (local.get $t_id)
      (local.get $l)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (i32.store (local.get $addr) (local.get $expr)) ;; node_addr

    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $ast (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (;;) (;;) (call $node
      (local.get $i)
      (local.get $len)
      (i32.const 0)
      (i32.const 2)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 6)))
    (i32.store8 (;;) (i32.const 5)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 0)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $expr))
      ;; node_addr

    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $emitToken (param $o i32) (param $token i32) (result i32)
    (local $i i32)
    (local $len i32)

    (local.set $i (i32.load (i32.add (local.get $token) (i32.const 1))))
    (local.set $len (i32.load (i32.add (local.get $token) (i32.const 5))))
    (loop $next (if (i32.lt_u (local.get $i) (local.get $len)) (then
      (local.set $o (call $w1 (local.get $o) (i32.load8_u (local.get $i))))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $next)
    )))
    (;;) (local.get $o)
  )

  (func $emitIdentifier
    (param $o i32)
    (param $addr i32)
    (param $assign i32)
    (result i32)

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1668246568)) ;; "(loc"
    (;;) (call $w3 (;;) (i32.const 3042401)) ;; "al."
    (if (param i32) (result i32) (local.get $assign) (then
      (;;) (call $w1 (;;) (i32.const 115)) ;; "s"
    ) (else
      (;;) (call $w1 (;;) (i32.const 103)) ;; "g"
    ))
    (;;) (call $w4 (;;) (i32.const 606106725)) ;; "et $"
    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
  )

  (func $emitCall (param $o i32) (param $addr i32) (result i32)
    (local $node i32)

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1818321704)) ;; "(cal"
    (;;) (call $w3 (;;) (i32.const 2367596)) ;; "l $"
    (;;) (call $emitToken
      (;;)
      (i32.load
        (i32.add
          (i32.load (i32.add (local.get $addr) (i32.const 2)))
          (i32.const 2)
        )
      )
    )
    (local.set $o (;;))

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (loop $next (if (local.get $node) (then
      (;;) (call $emitExpression
        (local.get $o)
        (i32.load (i32.add (local.get $node) (i32.const 4)))
        (i32.const 0)
      )
      (local.set $o (;;))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))

    (;;) (call $w1 (local.get $o) (i32.const 41)) ;; ")"
  )

  (func $emitPrimary (param $o i32) (param $addr i32) (result i32)
    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
    (;;) (call $w4 (;;) (i32.const 1852793646)) ;; ".con"
    (;;) (call $w3 (;;) (i32.const 2126963)) ;; "st "
    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
  )

  (func $emitUnary (param $o i32) (param $addr i32) (result i32)
    (local $token i32)

    (;;) (call $emitExpression
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 6)))
      (i32.const 0)
    )
    (local.set $o (;;))

    (local.set $token (i32.load (i32.add (local.get $addr) (i32.const 2))))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 2)) (then
        (return (local.get $o))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 3)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1819634990)) ;; ".mul"
      (;;) (call $w4 (;;) (i32.const 862529568)) ;; " (i3"
      (;;) (call $w4 (;;) (i32.const 1868770866)) ;; "2.co"
      (;;) (call $w4 (;;) (i32.const 544502638)) ;; "nst"
      (;;) (call $w4 (;;) (i32.const 690565421)) ;; "-1))"
      (return (;;))
    ))
    unreachable
  )

  (func $emitFactor (param $o i32) (param $addr i32) (result i32)
    (local $token i32)

    (;;) (call $emitExpression
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
      (i32.const 0)
    )
    (;;) (call $emitExpression
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 10)))
      (i32.const 0)
    )
    (local.set $o (;;))

    (local.set $token (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 4)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1819634990)) ;; ".mul"
      (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 5)) (then
      ;; div
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1986618414)) ;; ".div"
      (;;) (call $w3 (;;) (i32.const 2716511)) ;; "_s)"
      (return (;;))
    ))
    unreachable
  )

  (func $emitTerm (param $o i32) (param $addr i32) (result i32)
    (local $token i32)

    (;;) (call $emitExpression
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
      (i32.const 0)
    )
    (;;) (call $emitExpression
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 10)))
      (i32.const 0)
    )
    (local.set $o (;;))

    (local.set $token (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 2)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1684300078)) ;; ".add"
      (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 3)) (then
      ;; div
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1651864366)) ;; ".sub"
      (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
      (return (;;))
    ))
    unreachable
  )

  (func $emitCompare (param $o i32) (param $addr i32) (result i32)
    (local $token i32)

    (;;) (call $emitExpression
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
      (i32.const 0)
    )
    (;;) (call $emitExpression
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 10)))
      (i32.const 0)
    )
    (local.set $o (;;))

    (local.set $token (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 51)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 695297326)) ;; ".eq)"
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 53)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 694513198)) ;; ".ne)"
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 54)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1601465390)) ;; ".lt_"
      (;;) (call $w2 (;;) (i32.const 10611)) ;; "s)"
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 55)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1600482350)) ;; ".le_"
      (;;) (call $w2 (;;) (i32.const 10611)) ;; "s)"
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 56)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1601464110)) ;; ".gt_"
      (;;) (call $w2 (;;) (i32.const 10611)) ;; "s)"
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $token)) (i32.const 57)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230056)) ;; "(i32"
      (;;) (call $w4 (;;) (i32.const 1600481070)) ;; ".ge_"
      (;;) (call $w2 (;;) (i32.const 10611)) ;; "s)"
      (return (;;))
    ))
    unreachable
  )

  (func $emitExpression
    (param $o i32)
    (param $addr i32)
    (param $assign i32)
    (result i32)

    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 8)) (then
      (;;) (call $emitIdentifier
        (local.get $o)
        (local.get $addr)
        (local.get $assign)
      )
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 12)) (then
      (return (call $emitCall (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 1)) (then
      (return (call $emitPrimary (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 2)) (then
      (return (call $emitUnary (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 3)) (then
      (return (call $emitFactor (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 4)) (then
      (return (call $emitTerm (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 9)) (then
      (return (call $emitCompare (local.get $o) (local.get $addr)))
    ))
    unreachable
  )

  (func $emitAssign (param $o i32) (param $addr i32) (result i32)
    (;;) (call $emitExpression
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 6)))
      (i32.const 0)
    )
    (;;) (call $emitExpression
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
      (i32.const 1)
    )
  )

  (func $emitVariable (param $o i32) (param $addr i32) (result i32)
    (;;) (call $emitExpression
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 6)))
      (i32.const 0)
    )
    (;;) (call $w4 (;;) (i32.const 1668246568)) ;; "(loc"
    (;;) (call $w4 (;;) (i32.const 1932422241)) ;; "al.s"
    (;;) (call $w4 (;;) (i32.const 606106725)) ;; et $
    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
  )

  (func $emitIf (param $o i32) (param $addr i32) (result i32)
    (local $node i32)

    (;;) (call $emitExpression
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
      (i32.const 0)
    )
    (;;) (call $w4 (;;) (i32.const 677800232)) ;; "(if("
    (;;) (call $w4 (;;) (i32.const 1852139636)) ;; "then"
    (local.set $o (;;))

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (loop $next (if (local.get $node) (then
      (;;) (call $emitStatement
        (local.get $o)
        (i32.load (i32.add (local.get $node) (i32.const 4)))
      )
      (local.set $o (;;))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 10))))
    (if (local.get $node) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 1818568745)) ;; ")(el"
      (;;) (call $w2 (;;) (i32.const 25971)) ;; "se"
      (local.set $o (;;))
    ))
    (loop $next (if (local.get $node) (then
      (;;) (call $emitStatement
        (local.get $o)
        (i32.load (i32.add (local.get $node) (i32.const 4)))
      )
      (local.set $o (;;))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))

    (;;) (call $w2 (local.get $o) (i32.const 10537)) ;; "))"
  )

  (func $emitStatement (param $o i32) (param $addr i32) (result i32)
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 13)) (then
      (return (call $emitIf (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 6)) (then
      (return (call $emitVariable (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 7)) (then
      (return (call $emitAssign (local.get $o) (local.get $addr)))
    ))
    (;;) (call $emitExpression (local.get $o) (local.get $addr) (i32.const 0))
    (return (;;))
  )

  (func $emitDeclaration (param $o i32) (param $addr i32) (result i32)
    (if (i32.ne (i32.load8_u (local.get $addr)) (i32.const 6)) (then
      ;; check if statements
      (return (local.get $o))
    ))

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1668246568)) ;; "(loc"
    (;;) (call $w4 (;;) (i32.const 606104673)) ;; "al $"
    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )

    (;;) (call $emitType
      (;;)
      (i32.load8_u
        (i32.add
          (i32.load (i32.add (local.get $addr) (i32.const 6)))
          (i32.const 1)
        )
      )
    )
    (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
  )

  (func $emitType (param $o i32) (param $type i32) (result i32)
    (if (i32.eq (local.get $type) (i32.const 2)) (then
      (;;) (call $w4 (local.get $o) (i32.const 842230048)) ;; " i32"
      (return (;;))
    ))
    unreachable
  )

  (func $emitArgument (param $o i32) (param $addr i32) (result i32)
    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1918988328)) ;; "(par"
    (;;) (call $w4 (;;) (i32.const 606104929)) ;; "am $"
    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (;;) (call $emitType
      (;;)
      (i32.load8_u (i32.add (local.get $addr) (i32.const 1)))
    )
    (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
  )

  (func $emitFunction (param $o i32) (param $addr i32) (result i32)
    (local $node i32)
    (local $expr i32)

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1853187624)) ;; "(fun"
    (;;) (call $w3 (;;) (i32.const 2367587)) ;; "c $"
    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (if
      (param i32)
      (result i32)
      (i32.load8_u (i32.add (local.get $addr) (i32.const 15)))
      (then
        (;;) (call $w4 (;;) (i32.const 1886938408)) ;; "(exp"
        (;;) (call $w4 (;;) (i32.const 544502383)) ;; "ort "
        (;;) (call $w1 (;;) (i32.const 34)) ;; """
        (;;) (call $emitToken
          (;;)
          (i32.load (i32.add (local.get $addr) (i32.const 2)))
        )
        (;;) (call $w2 (;;) (i32.const 10530)) ;; ")""
      )
      (else)
    )
    (local.set $o (;;))

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (loop $next (if (local.get $node) (then
      (;;) (i32.load (i32.add (local.get $node) (i32.const 4)))
      (;;) (local.tee $expr (;;))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 11)) (then
        (local.set $o (call $emitArgument (local.get $o) (local.get $expr)))
        (local.set $node (i32.load (local.get $node)))
        (br $next)
      ))
      unreachable
    )))

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1936028200)) ;; "(res"
    (;;) (call $w3 (;;) (i32.const 7629941)) ;; "ult"
    (;;) (call $emitType
      (;;)
      (i32.load8_u (i32.add (local.get $addr) (i32.const 10)))
    )
    (;;) (call $w1 (;;) (i32.const 41)) ;; ")"
    (local.set $o (;;))

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 11))))
    (loop $next (if (local.get $node) (then
      (;;) (call $emitDeclaration
        (local.get $o)
        (i32.load (i32.add (local.get $node) (i32.const 4)))
      )
      (local.set $o (;;))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 11))))
    (loop $next (if (local.get $node) (then
      (;;) (call $emitStatement
        (local.get $o)
        (i32.load (i32.add (local.get $node) (i32.const 4)))
      )
      (local.set $o (;;))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))

    (;;) (call $w1 (local.get $o) (i32.const 41)) ;; ")"
  )

  (func $emitRoot (param $o i32) (param $root i32) (result i32)
    (local $node i32)
    (local $expr i32)

    (if (i32.ne (i32.load8_u (local.get $root)) (i32.const 5)) (then
      unreachable
    ))

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1685024040)) ;; "(mod"
    (;;) (call $w3 (;;) (i32.const 6646901)) ;; "ule"
    (local.set $o (;;))

    (local.set $node (i32.load (i32.add (local.get $root) (i32.const 2))))
    (loop $next (if (local.get $node) (then
      (;;) (i32.load (i32.add (local.get $node) (i32.const 4)))
      (;;) (local.tee $expr (;;))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 10)) (then
        (local.set $o (call $emitFunction (local.get $o) (local.get $expr)))
        (local.set $node (i32.load (local.get $node)))
        (br $next)
      ))
      unreachable
    )))

    (;;) (call $w1 (local.get $o) (i32.const 41)) ;; ")"
  )

  (func (export "compile") (param $size i32) (result i32 i32 i32)
    ;; (has_error, start_addr, end_addr)
    (local $has_error i32)
    (local $addr i32)

    (call $reset)
    (;;) (;;) (call $scan (global.get $alloc) (local.get $size))
    (local.set $addr (;;))
    (;;) (local.tee $has_error (;;))
    (if (i32.ne (;;) (i32.const 0)) (then
      (return (local.get $has_error) (local.get $addr) (local.get $addr))
    ))
    (call $set_alloc (local.get $addr))

    (;;) (;;) (call $ast
      (i32.add (local.get $size) (i32.const 1024))
      (local.get $addr)
    )
    (local.set $addr (;;))
    (;;) (local.tee $has_error (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
      (return (local.get $has_error) (local.get $addr) (local.get $addr))
    ))

    (;;) (i32.const 0)
    (;;) (call $get_alloc)
    (;;) (call $emitRoot (call $get_alloc) (local.get $addr))
  )

  (func $reset
    (global.set $alloc (i32.const 1024))
    (global.set $mem_end (i32.const 256))
  )

  (func $w4 (param $o i32) (param $x i32) (result i32)
    ;; (o)

    (i32.store (local.get $o) (local.get $x))
    (;;) (i32.add (local.get $o) (i32.const 4))
  )

  (func $w3 (param $o i32) (param $x i32) (result i32)
    ;; (o)

    (i32.store (local.get $o) (local.get $x))
    (;;) (i32.add (local.get $o) (i32.const 3))
  )

  (func $w2 (param $o i32) (param $x i32) (result i32)
    ;; (o)

    (i32.store (local.get $o) (local.get $x))
    (;;) (i32.add (local.get $o) (i32.const 2))
  )

  (func $w1 (param $o i32) (param $x i32) (result i32)
    ;; (o)

    (i32.store (local.get $o) (local.get $x))
    (;;) (i32.add (local.get $o) (i32.const 1))
  )
)
