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
    cpf = cpf.to_s
    return false unless cpf =~ SIZE_VALIDATION

    return false if DENY_LIST.include?(cpf)

    index = 10
    soma1 = 0
    soma2 = 0
    cpf.each_char do |numero|
      soma1 += numero.to_i * index
      break if index == 2

      index -= 1
    end
    dig1 = 11 - (soma1 % 11)
    return false if dig1 > 9 && cpf.chars[-2].to_i != 0 || dig1 <= 9 && cpf.chars[-2].to_i != dig1

    index = 11
    cpf.each_char do |numero|
      soma2 += numero.to_i * index
      break if index == 2

      index -= 1
    end
    dig2 = 11 - (soma2 % 11)
    return false if dig2 > 9 && cpf.chars[-1].to_i != 0 || dig2 <= 9 && cpf.chars[-1].to_i != dig2

    true
  end
end
