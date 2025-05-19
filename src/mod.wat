(module
    (memory (export "memory") 1)

    (global $alloc (mut i32) (i32.const 256))
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

        (global.get $alloc)
        (global.set $alloc (i32.add (global.get $alloc) (local.get $size)))
    )

    (func $set_alloc (param $addr i32) (result)
        (global.set $alloc (local.get $addr))
    )

    (data (i32.const 0) "\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00")
    (data (i32.const 16) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 32) "\01\00\00\00\00\00\00\00\00\00\04\02\00\03\00\05")
    (data (i32.const 48) "\06\06\06\06\06\06\06\06\06\06\00\00\00\00\00\00")
    (data (i32.const 64) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 80) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 96) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 112) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
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

        (local.tee $i (i32.const 256))
        (local.tee $size (i32.add (;;) (local.get $size)))
        (local.set $o (;;))

        (loop $next (if (i32.lt_u (local.get $i) (local.get $size)) (then
            (local.tee $char (i32.load8_u (i32.load8_u (local.get $i))))
            (if (i32.eqz (;;)) (then
                (return (i32.const 1) (local.get $i))
            ))
            (if (i32.eq (local.get $char) (i32.const 1)) (then
                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $next)
            ))
            (if (i32.ge_u (local.get $char) (i32.const 2)) (then
                (if (i32.le_u (local.get $char) (i32.const 5)) (then
                    (i32.store8 (local.get $o) (local.get $char))
                    (local.tee $o (i32.add (local.get $o) (i32.const 1)))
                    (local.get $i)
                    (i32.store (;;) (;;))
                    (local.tee $o (i32.add (local.get $o) (i32.const 4)))
                    (local.tee $i (i32.add (local.get $i) (i32.const 1)))
                    (i32.store (;;) (;;))
                    (local.set $o (i32.add (local.get $o) (i32.const 4)))
                    (br $next)
                ))
            ))
            (if (i32.eq (local.get $char) (i32.const 6)) (then
                (i32.store8 (local.get $o) (local.get $char))
                (local.tee $o (i32.add (local.get $o) (i32.const 1)))
                (local.get $i)
                (i32.store (;;) (;;))
                (loop $num
                    (local.tee $i (i32.add (local.get $i) (i32.const 1)))
                    (br_if $num
                        (i32.eq (i32.load8_u (i32.load8_u (;;))) (i32.const 6))
                    )
                )
                (local.tee $o (i32.add (local.get $o) (i32.const 4)))
                (local.get $i)
                (i32.store (;;) (;;))
                (local.set $o (i32.add (local.get $o) (i32.const 4)))
                (br $next)
            ))
            unreachable
        )))
        (i32.const 0)
        (local.get $o)
    )

    (func $primary (param $i i32) (param $len i32) (result i32 i32) ;; (i | error, addr)
        (local $addr i32)

        (if (i32.ge_u (local.get $i) (local.get $len)) (then
            (return (i32.const 2) (local.get $i))
        ))
        (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 6)) (then
            (return (i32.const 3) (local.get $i))
        ))

        (local.tee $addr (call $alloc (i32.const 5)))
        (i32.store8 (;;) (i32.const 1))
        (i32.store (i32.add (local.get $addr) (i32.const 1)) (local.get $i))

        (i32.add (local.get $i) (i32.const 9))
        (local.get $addr)
    )

    (func $unary (param $i i32) (param $len i32) (result i32 i32)
        ;; (i | error, addr)
        (local $addr i32)
        (local $enum i32)
        (local $expr i32)

        (if (i32.ge_u (local.get $i) (local.get $len)) (then
            (return (i32.const 2) (local.get $i))
        ))

        (block $break (loop $loop
            (local.tee $enum (i32.load8_u (local.get $i)))
            (if (i32.ne (;;) (i32.const 2)) (then
                (if (i32.ne (local.get $enum) (i32.const 3)) (then
                    (br $break)
                ))
            ))

            (local.get $addr)
            (local.tee $addr (call $alloc (i32.const 9)))
            (i32.store (i32.add (;;) (i32.const 5)) (;;)) ;; expr_addr
            (i32.store8 (local.get $addr) (i32.const 2)) ;; id
            (i32.store
                (i32.add (local.get $addr) (i32.const 1))
                (local.get $i)
            ) ;; token_addr

            (local.tee $i (i32.add (local.get $i) (i32.const 9)))
            (if (i32.ge_u (;;) (local.get $len)) (then
                (return (i32.const 2) (local.get $i))
            ))
            (br $loop)
        ))

        (if (i32.eqz (local.get $addr)) (then
            (call $primary (local.get $i) (local.get $len))
            (return (;;) (;;))
        ))
        (call $primary (local.get $i) (local.get $len))
        (local.set $expr (;;))
        (local.tee $i (;;))
        (if (i32.lt_u (;;) (i32.const 256)) (then
            (return (local.get $i) (local.get $expr))
        ))
        (i32.store (i32.add (local.get $addr) (i32.const 5)) (local.get $expr))
        (local.get $i)
        (local.get $addr)
    )

    (func $factor (param $i i32) (param $len i32) (result i32 i32)
        ;; (i | error, addr)
        (local $addr i32)
        (local $enum i32)
        (local $expr i32)

        (call $unary (local.get $i) (local.get $len))
        (local.set $expr (;;))
        (local.tee $i (;;))
        (if (i32.lt_u (;;) (i32.const 256)) (then
            (return (local.get $i) (local.get $expr))
        ))
        (if (i32.ge_u (local.get $i) (local.get $len)) (then
            (return (local.get $i) (local.get $expr))
        ))

        (block $break (loop $loop
            (local.tee $enum (i32.load8_u (local.get $i)))
            (if (i32.ne (;;) (i32.const 4)) (then
                (if (i32.ne (local.get $enum) (i32.const 5)) (then
                    (br $break)
                ))
            ))

            (local.tee $addr (call $alloc (i32.const 13)))
            (i32.store8 (;;) (i32.const 3)) ;; id
            (i32.store
                (i32.add (local.get $addr) (i32.const 1))
                (local.get $expr)
            ) ;; expr_addr1
            (i32.store
                (i32.add (local.get $addr) (i32.const 5))
                (local.get $i)
            ) ;; token_addr

            (call $unary
                (i32.add (local.get $i) (i32.const 9))
                (local.get $len)
            )
            (local.set $expr (;;))
            (local.tee $i (;;))
            (if (i32.lt_u (;;) (i32.const 256)) (then
                (return (local.get $i) (local.get $expr))
            ))
            (i32.store
                (i32.add (local.get $addr) (i32.const 9))
                (local.get $expr)
            ) ;; expr_addr2

            (if (i32.ge_u (local.get $i) (local.get $len)) (then
                (br $break)
            ))
            (local.set $expr (local.get $addr))
            (br $loop)
        ))

        (local.get $i)
        (local.get $expr)
    )

    (func $term (param $i i32) (param $len i32) (result i32 i32)
        ;; (i | error, addr)
        (local $addr i32)
        (local $enum i32)
        (local $expr i32)

        (call $factor (local.get $i) (local.get $len))
        (local.set $expr (;;))
        (local.tee $i (;;))
        (if (i32.lt_u (;;) (i32.const 256)) (then
            (return (local.get $i) (local.get $expr))
        ))
        (if (i32.ge_u (local.get $i) (local.get $len)) (then
            (return (local.get $i) (local.get $expr))
        ))

        (block $break (loop $loop
            (local.tee $enum (i32.load8_u (local.get $i)))
            (if (i32.ne (;;) (i32.const 2)) (then
                (if (i32.ne (local.get $enum) (i32.const 3)) (then
                    (br $break)
                ))
            ))

            (local.tee $addr (call $alloc (i32.const 13)))
            (i32.store8 (;;) (i32.const 4)) ;; id
            (i32.store
                (i32.add (local.get $addr) (i32.const 1))
                (local.get $expr)
            ) ;; expr_addr1
            (i32.store
                (i32.add (local.get $addr) (i32.const 5))
                (local.get $i)
            ) ;; token_addr

            (call $factor
                (i32.add (local.get $i) (i32.const 9))
                (local.get $len)
            )
            (local.set $expr (;;))
            (local.tee $i (;;))
            (if (i32.lt_u (;;) (i32.const 256)) (then
                (return (local.get $i) (local.get $expr))
            ))
            (i32.store
                (i32.add (local.get $addr) (i32.const 9))
                (local.get $expr)
            ) ;; expr_addr2

            (if (i32.ge_u (local.get $i) (local.get $len)) (then
                (br $break)
            ))
            (local.set $expr (local.get $addr))
            (br $loop)
        ))

        (local.get $i)
        (local.get $expr)
    )

    (func $ast (param $i i32) (param $len i32) (result i32 i32)
        ;; (i | error, addr)
        (local $addr i32)
        (local $enum i32)

        (call $term (local.get $i) (local.get $len))
        (local.set $addr (;;))
        (local.tee $i (;;))
        (if (i32.lt_u (;;) (i32.const 256)) (then
            (return (local.get $i) (local.get $addr))
        ))

        (local.tee $enum (i32.load8_u (local.get $addr)))
        (if (i32.eq (;;) (i32.const 1)) (then
            (return (local.get $i) (i32.add (local.get $addr) (i32.const 5)))
        ))
        (if (i32.eq (local.get $enum) (i32.const 2)) (then
            (return (local.get $i) (i32.add (local.get $addr) (i32.const 9)))
        ))
        (if (i32.eq (local.get $enum) (i32.const 3)) (then
            (return (local.get $i) (i32.add (local.get $addr) (i32.const 13)))
        ))
        (if (i32.eq (local.get $enum) (i32.const 4)) (then
            (return (local.get $i) (i32.add (local.get $addr) (i32.const 13)))
        ))
        unreachable
    )

    (func (export "compile") (param $size i32) (result i32 i32 i32)
        ;; (has_error, start_addr, end_addr)
        (local $has_error i32)
        (local $addr i32)

        (call $scan (local.get $size))
        (local.set $addr (;;))
        (local.tee $has_error (;;))
        (if (i32.ne (;;) (i32.const 0)) (then
            (return (local.get $has_error) (local.get $addr) (local.get $addr))
        ))
        (call $set_alloc (local.get $addr))

        (i32.const 0)
        (local.get $addr)
        (call $ast
            (i32.add (local.get $size) (i32.const 256))
            (local.get $addr)
        )
        (local.set $addr (;;))
        (local.tee $has_error (;;))
        (if (i32.lt_u (;;) (i32.const 256)) (then
            (return (local.get $has_error) (local.get $addr) (local.get $addr))
        ))
        (local.get $addr)
    )
)
