(module
    (memory (export "memory") 1)
    (global $len (mut i32) (i32.const 65536))
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

    (func $next_token (param $i i32) (result i32 i32 i32) ;; x, s, e
        (local $x i32)
        (local $s i32)

        (loop $loop (if (i32.lt_u (local.get $i) (global.get $len)) (then
            (local.set $x (i32.load8_u (i32.load8_u (local.get $i))))

            (if (i32.eq (local.get $x) (i32.const 1)) (then
                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                br $loop
            ))
            (if (i32.ge_u (local.get $x) (i32.const 2)) (then
                (if (i32.le_u (local.get $x) (i32.const 5)) (then
                    (local.set $i (i32.add (local.get $i) (i32.const 1)))
                    (return (local.get $x) (local.get $i) (local.get $i))
                ))
            ))
            (if (i32.eq (local.get $x) (i32.const 6)) (then
                (local.set $s (local.get $i))
                (loop $num
                    (local.set $i (i32.add (local.get $i) (i32.const 1)))
                    (if (i32.lt_u (local.get $i) (global.get $len)) (then
                        (br_if $num
                            (i32.eq
                                (i32.load8_u (i32.load8_u (local.get $i)))
                                (i32.const 6)
                            )
                        )
                    ))
                )
                (return (i32.const 6) (local.get $s) (local.get $i))
            ))
            (return
                (i32.const -1)
                (local.get $i)
                (local.get $i)
            )
        )))

        i32.const 0
        i32.const 0
        i32.const 0
    )

    (func (export "scan") (param $i i32) (result i32 i32)
        (local $o i32)
        (local $x i32)
        (local $s i32)

        (local.set $o (i32.const 256))

        (loop $loop (if (i32.lt_u (local.get $i) (global.get $len)) (then
            (local.set $x
                (local.set $s (local.set $i (call $next_token (local.get $i))))
            )
            (if (i32.eqz (local.get $x)) (then
                (return (local.get $o) (i32.const 0))
            ))
            (if (i32.eq (local.get $x) (i32.const -1)) (then
                (return (i32.load8_u (local.get $s)) (i32.const 1))
            ))
            (i32.store8 (local.get $o) (local.get $x))
            (local.set $o (i32.add (local.get $o) (i32.const 1)))
            (if (i32.sub (local.get $i) (local.get $s)) (then
                (i32.store8
                    (local.get $o)
                    (i32.sub (local.get $i) (local.get $s))
                )
                (local.set $o (i32.add (local.get $o) (i32.const 1)))

                (loop $copy
                    (i32.store8 (local.get $o) (i32.load8_u (local.get $s)))
                    (local.set $o (i32.add (local.get $o) (i32.const 1)))
                    (local.set $s (i32.add (local.get $s) (i32.const 1)))
                    (br_if $copy (i32.lt_u (local.get $s) (local.get $i)))
                )
            ))
            br $loop
        )))

        local.get $o
        i32.const 0
    )
)
