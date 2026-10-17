G.FUNCS.im_feeling_lucky = function(e)
    local unlocked_decks = {}
    for k, v in pairs(G.P_CENTERS) do
        if v.set == 'Back' and v.unlocked then
            --TODO(denneyl): make challenge decks optionally here
            if (string.find(v.key, "challenge")) then
                --print(v.key, " is a challenge deck, skipping")
            else
                table.insert(unlocked_decks, v)
            end
        end
    end

    --randomly select a deck
    math.randomseed(os.time())
    local deck = unlocked_decks[math.random(1, #unlocked_decks)]

    --randomly select a stake (need to know which stakes are unlocked)
    local unlocked_stakes = get_unlocked_stakes(deck)
    local stake = math.random(1, #unlocked_stakes)

    --need to set the back as a global constant but pass the stake in as an argument...
    --thunk, why did you do this???
    G.GAME.selected_back = Back(deck)
    G.FUNCS.start_run(e, {stake = stake})
end


G.UIDEF.im_feeling_lucky_setup_option = function()
    return
    {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR, minh = 6.6, minw = 6}, nodes={
        UIBox_button{id = 'imfeelinglucky', button = "im_feeling_lucky", colour = G.C.BLUE, minw = 3.65, minh = 1.55, label = {"I'm Feeling Lucky!!"}, scale = 0.90, col = true}
    }}
end


get_unlocked_stakes = function(back)
    --look up the back in the profiles table
    deck_info = G.PROFILES[G.SETTINGS.profile].deck_usage[back.key] or {}
    stakes = {}
    for key, _ in pairs(deck_info.wins_by_key or {}) do
        table.insert(stakes, key)
    end

    --todo i think we can clean this up because we don't care about the names of the stakes, just their numbers...

    -- this is just the stakes that the player has already won on
    -- we still need to unlock one more stake (unless they already have all the stakes)
    if #stakes >= 8 then return stakes end -- all stakes already unlocked

    add_stake = vanilla_stakes[#stakes]
    table.insert(stakes, add_stake)

    --todo add a setting that lets us use any stake, even if it isn't unlocked

    return stakes
end

vanilla_stakes = {
    "stake_white",
    "stake_red",
    "stake_green",
    "stake_black",
    "stake_blue",
    "stake_purple",
    "stake_orange",
    "stake_gold",
}
