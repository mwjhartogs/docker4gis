create or replace function public.fn_pre_request()
returns void
language plpgsql
as $$
declare
    claim_iat text;
begin
	if current_user = 'web_anon'
	then
		return;
	end if
	;
	claim_iat :=
        current_setting('request.jwt.claim.iat', true)
    ;
    if claim_iat = '' or claim_iat::bigint < public.fn_get_user_exp(current_user)
    then
        raise invalid_authorization_specification
        using message = 'please reauthenticate';
    end if
	;
end;
$$;

grant execute on function public.fn_pre_request()
to public
;
