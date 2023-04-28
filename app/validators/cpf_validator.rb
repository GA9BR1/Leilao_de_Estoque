class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if cpf_valid?(value)

    record.errors.add(
      attribute,
      :invalid_cpf,
      message: options[:message] || 'is not valid',
      value: value
    )
  end

  private

  DENY_LIST = %w[
    00000000000
    11111111111
    22222222222
    33333333333
    44444444444
    55555555555
    66666666666
    77777777777
    88888888888
    99999999999
    12345678909
    01234567890
  ].freeze

  SIZE_VALIDATION = /^[0-9]{11}$/

  def cpf_valid?(cpf)
    return false unless cpf =~ SIZE_VALIDATION

    return false if DENY_LIST.include?(cpf)

    cpf = cpf.chars

    dig1 = []
    dig2 = []
    modt = 0

    cpf.zip(10.downto(2).to_a) do |num, multi|
      dig1 << (num.to_i * multi.to_i)
    end
    somadig1 = dig1.sum
    mod1 = 11 - (somadig1 % 11)
    cpf.zip(11.downto(2).to_a) do |num, multi|
      num = num.to_i
      multi = multi.to_i
      if multi > 2
        dig2 << num * multi
      elsif multi == 2
        modt = mod1 if mod1 <= 9
        dig2 << modt * multi
      end
    end
    somadig2 = dig2.sum
    mod2 = 11 - (somadig2 % 11)
    return true if (mod1 > 9 && cpf[-2] == '0' || mod1 <= 9 && cpf[-2] == mod1.to_s) &&
                   (mod2 > 9 && cpf[-1] == '0' || mod2 <= 9 && cpf[-1] == mod2.to_s)

    false
  end
end
