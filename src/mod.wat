(module
  (import "./log.ts" "log" (func $log (param i32)))
  (import "./log.ts" "spy" (func $spy (param i32) (result i32)))

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
  (func $mem_set (param $type i32) (param $expr i32) (result i32)
    ;; (out_of_memory)
    (local $addr i32)

    (if (i32.ge_u (global.get $mem_end) (i32.const 1024)) (then
      (return (i32.const 1))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 5)))
    (i32.store8 (;;) (local.get $type)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 1)) (local.get $expr))
      ;; expr_addr
    (i32.store (global.get $mem_end) (local.get $addr))
    (global.set $mem_end (i32.add (global.get $mem_end) (i32.const 4)))

    (;;) (i32.const 0)
  )

  (func $mem_get_var (param $token i32) (result i32)
    ;; (addr)
    (local $mem i32)
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
      (local.set $mem (i32.load (local.get $i)))
      (if (i32.eq (i32.load8_u (local.get $mem)) (i32.const 1)) (then
        (;;) (i32.load (i32.add (local.get $mem) (i32.const 1)))
        (;;) (i32.load (i32.add (;;) (i32.const 2)))
        (local.set $t (;;))
        (;;) (i32.sub
          (i32.add (local.get $t) (i32.const 5))
          (i32.add (local.get $t) (i32.const 1))
        )
        (if (i32.eq (;;) (local.get $len)) (then
          (if (call $eq_token (local.get $t) (local.get $token)) (then
            (return (i32.load (i32.add (local.get $mem) (i32.const 1))))
          ))
        ))
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 4)))
      (br $next)
    )))

    (;;) (i32.const 0)
  )

  (func $mem_get_func (param $token i32) (result i32)
    ;; (addr)
    (local $mem i32)
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
      (local.set $mem (i32.load (local.get $i)))
      (if (i32.eq (i32.load8_u (local.get $mem)) (i32.const 2)) (then
        (;;) (i32.load (i32.add (local.get $mem) (i32.const 1)))
        (;;) (i32.load (i32.add (;;) (i32.const 2)))
        (local.set $t (;;))
        (;;) (i32.sub
          (i32.add (local.get $t) (i32.const 5))
          (i32.add (local.get $t) (i32.const 1))
        )
        (if (i32.eq (;;) (local.get $len)) (then
          (if (call $eq_token (local.get $t) (local.get $token)) (then
            (return (i32.load (i32.add (local.get $mem) (i32.const 1))))
          ))
        ))
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 4)))
      (br $next)
    )))

    (;;) (i32.const 0)
  )

  (func $mem_get_argu (param $token i32) (result i32)
    ;; (addr)
    (local $mem i32)
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
      (local.set $mem (i32.load (local.get $i)))
      (if (i32.eq (i32.load8_u (local.get $mem)) (i32.const 3)) (then
        (;;) (i32.load (i32.add (local.get $mem) (i32.const 1)))
        (;;) (i32.load (i32.add (;;) (i32.const 2)))
        (local.set $t (;;))
        (;;) (i32.sub
          (i32.add (local.get $t) (i32.const 5))
          (i32.add (local.get $t) (i32.const 1))
        )
        (if (i32.eq (;;) (local.get $len)) (then
          (if (call $eq_token (local.get $t) (local.get $token)) (then
            (return (i32.load (i32.add (local.get $mem) (i32.const 1))))
          ))
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

  (func $scan (param $size i32) (result i32 i32)
    ;; (has_error, addr)
    (local $i i32)
    (local $o i32)
    (local $char i32)

    (;;) (local.tee $i (i32.const 1024))
    (;;) (local.tee $size (i32.add (;;) (local.get $size)))
    (local.set $o (;;))

    (loop $next (if (i32.lt_u (local.get $i) (local.get $size)) (then
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
    (if (i32.eq (i32.load8_u (;;)) (i32.const 102)) (then
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
      ))
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
    ))))))
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

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 101)) (then
      (return (i32.const 0) (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 6)))
    (i32.store8 (;;) (i32.const 8)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 2)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; token_addr

    (if (i32.and
      (i32.eqz (call $mem_get_var (local.get $i)))
      (i32.eqz (call $mem_get_argu (local.get $i)))
    ) (then
      (return (i32.const 0) (i32.const 7) (local.get $i))
    ))

    (;;) (i32.const 1)
    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $primary (param $i i32) (result i32 i32 i32)
    ;; (isAssignable, <1024 ? error : i, addr)
    (local $addr i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 100)) (then
      (;;) (;;) (;;) (call $identifier (local.get $i))
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
        (;;) (;;) (;;) (call $primary (local.get $i))
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
    (if (call $mem_get_var (local.get $i)) (then
      (return (i32.const 6) (local.get $i))
    ))
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; identifier_token_addr
    (if (call $mem_set (i32.const 1) (local.get $addr)) (then
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

  (func $stmt (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)

    (;;) (;;) (call $var (local.get $i) (local.get $len))
    (local.set $addr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 1024)) (then
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

  (func $argu (param $i i32) (param $len i32) (result i32 i32)
    ;; (<1024 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 101)) (then
      (return (i32.const 3) (local.get $i))
    ))
    (if (call $mem_get_argu (local.get $i)) (then
      (return (i32.const 6) (local.get $i))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 6)))
    (i32.store8 (;;) (i32.const 11)) ;; id
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; identifier_token_addr
    (if (call $mem_set (i32.const 3) (local.get $addr)) (then
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
      (return (local.get $i) (local.get $len))
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
    (if (call $mem_get_func (local.get $i)) (then
      (return (i32.const 6) (local.get $i))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 15)))
    (i32.store8 (;;) (i32.const 10)) ;; id
    (i32.store8 (i32.add (local.get $addr) (i32.const 1)) (i32.const 0)) ;; type
    (i32.store (i32.add (local.get $addr) (i32.const 2)) (local.get $i))
      ;; identifier_token_addr
    (if (call $mem_set (i32.const 2) (local.get $addr)) (then
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

  (func $emitToken (param $o i32) (param $t i32) (result i32)
    ;; (o)
    (local $i i32)
    (local $len i32)

    (local.set $i (i32.load (i32.add (local.get $t) (i32.const 1))))
    (local.set $len (i32.load (i32.add (local.get $t) (i32.const 5))))
    (loop $next (if (i32.lt_u (local.get $i) (local.get $len)) (then
      (local.set $o (call $w1 (local.get $o) (i32.load8_u (local.get $i))))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $next)
    )))
    (;;) (local.get $o)
  )

  (func $emitIdentifier (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1668246560)) ;;  loc
    (;;) (call $w4 (;;) (i32.const 1731095649)) ;; al.g
    (;;) (call $w4 (;;) (i32.const 606106725)) ;; et $

    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
  )

  (func $emitPrimary (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 842230048)) ;;  i32
    (;;) (call $w4 (;;) (i32.const 1852793646)) ;; .con
    (;;) (call $w3 (;;) (i32.const 2126963)) ;; "st "

    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
  )

  (func $emitUnary (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 6)))
    )
    (local.set $o (;;))
    (local.set $addr (i32.load (i32.add (local.get $addr) (i32.const 2))))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 2)) (then
      (return (local.get $o))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 3)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;;  i32
      (;;) (call $w4 (;;) (i32.const 1852793646)) ;; .con
      (;;) (call $w4 (;;) (i32.const 757101683)) ;; st -
      (;;) (call $w4 (;;) (i32.const 862527537)) ;; 1 i3
      (;;) (call $w4 (;;) (i32.const 1970089522)) ;; 2.mu
      (;;) (call $w1 (;;) (i32.const 108)) ;; l
      (return (;;))
    ))
    unreachable
  )

  (func $emitFactor (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 10)))
    )
    (local.set $o (;;))
    (local.set $addr (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 4)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;;  i32
      (;;) (call $w4 (;;) (i32.const 1819634990)) ;; .mul
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 5)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;;  i32
      (;;) (call $w4 (;;) (i32.const 1986618414)) ;; .div
      (;;) (call $w2 (;;) (i32.const 29535)) ;; _s
      (return (;;))
    ))
    unreachable
  )

  (func $emitTerm (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 10)))
    )
    (local.set $o (;;))
    (local.set $addr (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 2)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
      (;;) (call $w4 (;;) (i32.const 1684300078)) ;; .add
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 3)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;;  i32
      (;;) (call $w4 (;;) (i32.const 1651864366)) ;; .sub
      (return (;;))
    ))
    unreachable
  )

  (func $emitCompare (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 10)))
    )
    (local.set $o (;;))
    (local.set $addr (i32.load (i32.add (local.get $addr) (i32.const 6))))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 51)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
      (;;) (call $w3 (;;) (i32.const 7431470)) ;; .eq
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 53)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
      (;;) (call $w3 (;;) (i32.const 6647342)) ;; .ne
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 54)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
      (;;) (call $w4 (;;) (i32.const 1601465390)) ;; .lt_
      (;;) (call $w1 (;;) (i32.const 117)) ;; u
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 55)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
      (;;) (call $w4 (;;) (i32.const 1600482350)) ;; .le_
      (;;) (call $w1 (;;) (i32.const 117)) ;; u
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 56)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
      (;;) (call $w4 (;;) (i32.const 1601464110)) ;; .gt_
      (;;) (call $w1 (;;) (i32.const 117)) ;; u
      (return (;;))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 57)) (then
      (;;) (local.get $o)
      (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
      (;;) (call $w4 (;;) (i32.const 1600481070)) ;; .ge_
      (;;) (call $w1 (;;) (i32.const 117)) ;; u
      (return (;;))
    ))
    unreachable
  )

  (func $emitAssign (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (call $emitExpr
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 6)))
    )

    (;;) (call $w4 (;;) (i32.const 1668246560)) ;;  loc
    (;;) (call $w4 (;;) (i32.const 1932422241)) ;; al.s
    (;;) (call $w4 (;;) (i32.const 606106725)) ;; et $

    (;;) (local.tee $addr (i32.load (i32.add (local.get $addr) (i32.const 2))))
    (if (i32.ne (i32.load8_u (;;)) (i32.const 8)) (then
      unreachable
    ))
    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
  )

  (func $emitVar (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (call $emitExpr
      (local.get $o)
      (i32.load (i32.add (local.get $addr) (i32.const 6)))
    )

    (;;) (call $w4 (;;) (i32.const 1668246560)) ;; " loc"
    (;;) (call $w4 (;;) (i32.const 1932422241)) ;; al.s
    (;;) (call $w4 (;;) (i32.const 606106725)) ;; et $

    (;;) (call $emitToken
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 2)))
    )
  )

  (func $emitExpr (param $o i32) (param $addr i32) (result i32)
    ;; (o)

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
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 6)) (then
      (return (call $emitVar (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 7)) (then
      (return (call $emitAssign (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 8)) (then
      (return (call $emitIdentifier (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 9)) (then
      (return (call $emitCompare (local.get $o) (local.get $addr)))
    ))
    unreachable
  )

  (func $emitScope (param $o i32) (param $addr i32) (result i32)
    ;; (o)
    (local $node i32)
    (local $expr i32)

    (if (i32.ne (i32.load8_u (local.get $addr)) (i32.const 5)) (then
      unreachable
    ))

    (;;) (local.get $o)
    (;;) (call $w4 (;;) (i32.const 1936028200)) ;; (res
    (;;) (call $w3 (;;) (i32.const 7629941)) ;; ult
    (local.set $o (;;))
    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 2))))
    (loop $next (if (local.get $node) (then
      (;;) (i32.load (i32.add (local.get $node) (i32.const 4)))
      (;;) (i32.add (;;) (i32.const 1))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 2)) (then
        (local.set $o (call $w4 (local.get $o) (i32.const 842230048))) ;; " i32"
      ))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))
    (local.set $o (call $w1 (local.get $o) (i32.const 41))) ;; )

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 2))))
    (loop $next (if (local.get $node) (then
      (;;) (i32.load (i32.add (local.get $node) (i32.const 4)))
      (;;) (local.tee $expr (;;))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 6)) (then
        (;;) (local.get $o)
        (;;) (call $w4 (;;) (i32.const 1668246568)) ;; (loc
        (;;) (call $w4 (;;) (i32.const 606104673)) ;; al $
        (;;) (call $emitToken
          (;;)
          (i32.load (i32.add (local.get $expr) (i32.const 2)))
        )
        (;;) (call $w4 (;;) (i32.const 842230048)) ;; " i32"
        (;;) (call $w1 (;;) (i32.const 41)) ;; )
        (local.set $o (;;))
      ))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))

    (local.set $node (i32.load (i32.add (local.get $addr) (i32.const 2))))
    (loop $next (if (local.get $node) (then
      (;;) (local.get $o)
      (;;) (i32.load (i32.add (local.get $node) (i32.const 4)))
      (local.set $o (call $emitExpr (;;) (;;)))
      (local.set $node (i32.load (local.get $node)))
      (br $next)
    )))

    (;;) (local.get $o)
  )

  (func $emitWat (param $root i32) (result i32)
    ;; (o)

    (if (i32.ne (i32.load8_u (local.get $root)) (i32.const 5)) (then
      unreachable
    ))

    (;;) (call $get_alloc)
    (;;) (call $w4 (;;) (i32.const 1685024040)) ;; (mod
    (;;) (call $w4 (;;) (i32.const 677735541)) ;; ule(
    (;;) (call $w4 (;;) (i32.const 1668183398)) ;; func
    (;;) (call $w4 (;;) (i32.const 1886938408)) ;; (exp
    (;;) (call $w4 (;;) (i32.const 544502383)) ;; "ort "
    (;;) (call $w4 (;;) (i32.const 1767992610)) ;; "mai
    (;;) (call $w3 (;;) (i32.const 2695790)) ;; n")

    (;;) (call $emitScope (;;) (local.get $root))

    (;;) (call $w2 (;;) (i32.const 10537)) ;; ))
  )

  (func (export "compile") (param $size i32) (result i32 i32 i32)
    ;; (has_error, start_addr, end_addr)
    (local $has_error i32)
    (local $addr i32)

    (;;) (;;) (call $scan (local.get $size))
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
    (;;) (call $emitWat (local.get $addr))
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
